# Animating effects

Run effects over time, freeze a frame, and drive effects from your own animations.

## Overview

Effects that change over time take a `time` argument of type ``ShaderTime``:
``SwiftUICore/View/wave(amplitude:wavelength:speed:time:)``,
``SwiftUICore/View/water(amplitude:scale:speed:time:)``,
``SwiftUICore/View/glitch(intensity:time:)``, ``SwiftUICore/View/filmGrain(intensity:time:)``
and ``SwiftUICore/View/shimmer(color:intensity:width:angle:duration:time:)``.

### Let the effect run

The default, ``ShaderTime/animated``, starts the clock when the view appears and redraws the
effect every frame with a `TimelineView`:

```swift
Rectangle()
    .fill(.stripes(width: 18, angle: .zero, .blue, .white))
    .frame(width: 240, height: 150)
    .wave(amplitude: 5, wavelength: 120, speed: 0.8)
```

``ShaderTime/animated(speed:)`` runs the clock faster, slower or backward. A disabled effect,
such as a shimmer with `intensity: 0`, does not start the timeline at all.

### Show one frame

``ShaderTime/fixed(_:)`` draws the frame at a given number of seconds and never redraws. Use it in
previews and snapshot tests, where a running clock would make every rendering different:

```swift
Text("Breaking news")
    .glitch(intensity: 0.6, time: .fixed(2))
```

### Drive the time yourself

A fixed time that you change is an animation you control. Feed it from a `TimelineView`, a
`keyframeAnimator` or a value that you animate with `withAnimation`:

```swift
struct Pulse: View {
    @State private var start = Date()

    var body: some View {
        TimelineView(.animation) { context in
            let seconds = context.date.timeIntervalSince(start)
            Image(systemName: "waveform")
                .font(.system(size: 80))
                .water(amplitude: 3, time: .fixed(seconds))
        }
    }
}
```

The ``SwiftUICore/ShapeStyle/plasma(time:scale:colors:)`` fill takes its time the same way, as a
number of seconds.

### Ripples

``SwiftUICore/View/rippleOnTap(style:duration:)`` starts a ripple wherever the view is tapped. The
tap is recognized alongside the view's own gestures, so buttons inside keep working:

```swift
RoundedRectangle(cornerRadius: 24)
    .fill(.blue.gradient)
    .frame(width: 280, height: 180)
    .rippleOnTap()
```

To start a ripple from code instead, animate the elapsed time of
``SwiftUICore/View/ripple(origin:elapsedTime:style:)``. ``RippleStyle`` sets how far the ripple
moves the view and how fast it spreads and fades.

### Long-running effects

Shaders compute in 32-bit floats, which cannot tell two times apart once the numbers grow large.
Animated time therefore wraps every hour, and fixed times wrap the same way:
`.fixed(3_605)` shows the frame of `.fixed(5)`. The wave, the shimmer and the film grain repeat
within an hour, so the wrap is not visible in them.

## See Also

- ``ShaderTime``
- <doc:HowEffectsAreDrawn>
