require 'libsvm'
module Selector
  class Svm

    PATH = "#{App.root}/storage/svm/"
    DEFAULT_C = 11
    DEFAULT_GAMMA = 1
    LOG_ACCURACY = true
    OPTIMIZE_PARAMS=false

    class SVMError < RuntimeError
    end

    def self.load(user_id)
      model = Libsvm::Model.load("#{PATH}#{user_id}")
      self.new(model: model, user_id: user_id)
    end

    def initialize(args = {})
      @model = args[:model]
      @user_id = args[:user_id]
    end

    def save
      @model.save("#{PATH}#{@user_id}")
    end

    def train(labels, examples)
      raise SVMError, "Empty train set is not allowed" if examples.nil? || examples.empty? || labels.nil?
      raise SVMError, "Labels and examples size mismatch" unless labels.count == examples.count
      @example_template = (0..examples[0].length-1).map {|i| Libsvm::Node.new(i,0)}
      find_extremes(examples)
      examples.map! { |f| scale_and_clone(f) }
      problem = Libsvm::Problem.new
      problem.set_examples(labels, examples)
      param = get_param(labels:labels, examples:examples)
      if LOG_ACCURACY
        accuracy = cross_validate labels: labels, examples: examples,
                                  chunk_size: [labels.count / 10, 1].max, c: param.c, gamma: param.gamma
        puts "------Accuracy: #{accuracy}"
      end
      @model = Libsvm::Model.train(problem, param)
    end

    def predict_probability(example)
      raise SVMError, "Nil example is not allowed" if example.nil?
      raise SVMError, "Model is not defined" if @model.nil?
      example = scale(example)
      result = @model.predict_probability(example)
      {label: result[0].round(0),
       prob: result[1][0] > (result[1][1] || 0) ? result[1][0] : result[1][1]}
    end

    private

    def rbf_parameter(c, gamma)
      parameter = Libsvm::SvmParameter.new
      parameter.cache_size = 1 # in megabytes
      parameter.gamma = gamma
      parameter.eps = 0.01
      parameter.c = c
      parameter.probability = 1
      parameter.kernel_type = Libsvm::KernelType::RBF
      parameter
    end

    def cross_validate(args = {})
      labels = args[:labels]
      examples = args[:examples]
      chunk_size = args[:chunk_size]
      c = args[:c]
      gamma = args[:gamma]
      steps = (labels.count - 1) / chunk_size + 1
      errors = 0
      steps.times do |i|
        training_examples = examples.clone
        training_labels = labels.clone
        test_examples = training_examples.slice!(i * chunk_size, chunk_size)
        test_labels = training_labels.slice!(i * chunk_size, chunk_size)
        problem = Libsvm::Problem.new
        problem.set_examples(training_labels, training_examples)
        param = rbf_parameter(c, gamma)
        model = Libsvm::Model.train(problem, param)
        test_labels.count.times do |i|
          errors +=1 unless test_labels[i] == model.predict(test_examples[i])
        end
      end
      1 - errors.to_f / labels.count
    end

    def find_extremes(examples)
      size = examples[0].length
      @min_vector = examples[0].clone
      @max_vector = examples[0].clone
      examples.each do |example|
        size.times do |i|
          @max_vector[i] = example[i] if example[i] > @max_vector[i]
          @min_vector[i] = example[i] if example[i] < @min_vector[i]
        end
      end
    end

    # This is optimized scale that uses prebuilt template
    # The result is valid only before the next call
    # This thing is way faster than with clone example
    def scale(example)
      example.length.times do |i|
        # note that if the vector outside training set contains new feature value
        # (and training set contained only one other value) it'll be ignored
        @example_template[i].value = @max_vector[i] == @min_vector[i] ? @max_vector[i]
          : (example[i] - @min_vector[i]).to_f / (@max_vector[i] - @min_vector[i])
      end
      @example_template
    end

    # This scale creates a clone of example
    def scale_and_clone(example)
      result = []
      example.length.times do |i|
        # note that if the vector outside training set contains new feature value
        # (and training set contained only one other value) it'll be ignored
        value = @max_vector[i] == @min_vector[i] ? @max_vector[i]
        : (example[i] - @min_vector[i]).to_f / (@max_vector[i] - @min_vector[i])
        result << Libsvm::Node.new(i, value)
      end
      result
    end


    # This block is for parameters optimization

    def get_param(args = {})
      labels = args[:labels]
      examples = args[:examples]
      best = (labels.nil? or not OPTIMIZE_PARAMS) ? {params: [DEFAULT_C, DEFAULT_GAMMA]}
        : find_optimal_parameters(labels, examples)
      rbf_parameter(best[:params][0], best[:params][1])
    end

    def find_optimal_parameters(labels, examples)
      best = {params: [], accuracy: 0}
      cs.each do |c|
        gammas.each do |gamma|
          accuracy = cross_validate labels: labels, examples: examples,
                                    chunk_size: [labels.count / 10, 1].max, c: c, gamma: gamma
          if accuracy > best[:accuracy]
            best[:accuracy] = accuracy
            best[:params] = [c, gamma]
          end
        end
      end
      best
    end


    def gammas
      result = []
      7.times do |i|
        result << 2 ** (i - 3)
      end
      result
    end

    def cs
      gammas
    end

  end
end