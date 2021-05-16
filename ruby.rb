require 'set'

compare = ->(a, b) do
  a = a.to_set
  b = b.flatten.to_set
  unless a == b
    a_b = a - b
    pp a_b unless a_b.empty?
    b_a = b - a
    pp b_a unless b_a.empty?
    fail
  end
end

list_methods = ->(a, public:, private:) do
  compare.(a.private_instance_methods(false), private.flatten)
  compare.(a.instance_methods(false), public.flatten)
end

list_methods.call BasicObject,
  public: [
    %i[ == != ! equal? ], # equality
    %i[ instance_eval instance_exec ], # eval
    :__id__,
    :__send__,
  ],
  private: [
    :initialize,
    :method_missing,
    %i[ singleton_method_added singleton_method_removed singleton_method_undefined ], # hooks
  ]

list_methods.call Object,
  public: [],
  private: [] # Object has nothing, it's neat I guess?

# Compare.call Kernel, []
