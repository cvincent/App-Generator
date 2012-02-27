module ControllerMacros
  def do_request
    self.send(
      request_method,
      request_action,
      request_params
    )
  end

  module ClassMethods
    def do_request
      before(:each) do
        do_request
      end
    end
  end

  protected

  def self.included(base)
    base.extend(ClassMethods)
    super
  end
end
