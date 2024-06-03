def reset
  $twidth = 20
  $tally = [0] * $twidth

  $gtk.set_rng(Time.new.to_f * 1000)
end

def wmaxrand(max = 0)
  x1 = rand(max)
  x2 = rand(max)
  x1 > x2 ? x1 : x2
end

def wminrand(max = 0)
  x1 = rand(max)
  x2 = rand(max)
  x1 <= x2 ? x1 : x2
end

def wminpwrand(max = 0, weight = 2)
  x1 = rand
  (x1**weight * max).floor
end

def wmaxpwrand(max = 0, weight = 2)
  x1 = rand
  x1w = x1**weight
  ((1 - x1w) * max).floor
end

def wmaxrtrand(max = 0, weight = 2)
  x1 = rand
  (x1**(1.0 / (weight * weight)) * max).floor
end

def wminrtrand(max = 0, weight = 2)
  x1 = rand
  x1w = x1**(1.0 / (weight * weight))
  ((1 - x1w) * max).floor
end

$gtk.disable_reset_via_ctrl_r

def tick(args)
  outputs = args.outputs
  outputs.background_color = { r: 0, g: 0, b: 0, a: 255 }

  width = 1280 / $twidth

  sum = $tally.sum

  outputs << ($twidth.map {
    {
      x: width * _1,
      y: 0,
      w: width,
      h: ($tally[_1] / (sum.nonzero? || 1)) * 720,
      path: :pixel
    }
  })

  $tally[wmaxpwrand($twidth, 2.0)] += 1

  kb = args.inputs.keyboard
  $gtk.reset if kb.key_down.r && kb.key_held.ctrl
end

reset

$gtk.reset
