def walker!(x, y, stride = 1)
  $walker = {
    x: x,
    y: y,
    w: stride * 2,
    h: stride * 2,
    anchor_x: 0.5,
    anchor_y: 0.5,
    stride: stride,
    previous: nil
  }
end

def walker_move
  $walker.previous = {**$walker.except(:previous)}
  $walker.previous.w /= 2.0
  $walker.previous.h /= 2.0

  dx = rand(3) - 1
  dy = rand(3) - 1

  stride = $walker.stride
  $walker.x += dx * stride
  $walker.y += dy * stride
end

def reset
  $front ||= :rt
  $back  ||= :tr
  $front, $back = $back, $front

  $outputs[$back].clear_before_render = true
  
  walker!(640, 360, 8)
  srand(t = Time.new.to_i)
  $gtk.set_rng(t)
end

$gtk.disable_reset_via_ctrl_r

def tick(args)
  outputs = args.outputs
  outputs.background_color = { r: 0, g: 0, b: 0, a: 255 }
  rt = outputs[$front]
  outputs[$back].transient!
  rt.clear_before_render = false
  rt.transient!
  rt.background_color = { r: 0, g: 0, b: 0, a: 0 }

  rt << {
    **$walker,
    g: 0,
    b: 0,
    path: :pixel
  }

  if $walker.previous
    rt << {
      **$walker.previous,
      path: :pixel
    }
  end

  outputs << {
    x: 0, y: 0,
    w: 1280, h: 720,
    path: $front
  }

  walker_move

  kb = args.inputs.keyboard
  $gtk.reset if kb.key_down.r && kb.key_held.ctrl
end

reset

$gtk.reset
