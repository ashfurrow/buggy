def random_fun_emoji
  ":" + %w(tada lollipop allthings 110 1up avocato badger devang drake_like fbwow hadouken handsup-celebrate koolaid lacroix-lime mega_wow mona nyancat oh_no_you_didnt_parrot powerup sarah shaka stas successkid tails yoshi yes raised_hands star-struck rainbow bugs white_check_mark cake popcorn heart heart_decoration heavy_heart_exclamation nail_care danceman face_with_cowboy_hat).sample + ":"
end

def random_emojis
  Array.new(rand(3..5)).map { random_fun_emoji }.join('')
end
