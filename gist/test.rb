require 'libsvm'

a=[1,2,6]
feature = Libsvm::Node::features(a)
puts feature[2].value