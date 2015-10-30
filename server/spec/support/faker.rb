module SecureFaker
  def image(*args)
    super(*args).sub('http://', 'https://')
  end
end

Faker::Avatar.singleton_class.prepend SecureFaker
