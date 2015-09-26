class Test < Crabfarm::BaseNavigator

  def run
    # just return params
    {
      foo: 'bar',
      params: params
    }
  end

end

