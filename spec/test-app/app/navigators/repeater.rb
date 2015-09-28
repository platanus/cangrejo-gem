class Repeater < Crabfarm::BaseNavigator

  def run

    if params[:raise]
      error = StandardError.new params[:raise]
      error.set_backtrace params[:backtrace]
      raise error
    end

    params[:repeat]
  end

end

