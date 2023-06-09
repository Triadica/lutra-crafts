
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.5)
    :modules $ [] |memof/ |quaternion/ |lagopus/
  :entries $ {}
  :files $ {}
    |app.comp.blow $ {}
      :defs $ {}
        |comp-blow $ quote
          defn comp-blow () $ let
              points $ fibo-grid-range 400
              width 0.016
            comp-curves $ {} (; :topology :line-list) (:shader wgsl-blow)
              :curves $ -> points
                mapcat $ fn (p)
                  apply-args
                      []
                      rand 100
                      , 4
                    fn (acc a step)
                      if (<= step 0) acc $ let
                          l $ + 40 (rand 160)
                          gap $ + 3 (rand 8)
                        recur
                          conj acc $ []
                            {}
                              :position $ v-scale p (+ gap a)
                              :width $ * (+ gap a) width
                            {}
                              :position $ v-scale p (+ a gap l)
                              :width $ * (+ a gap l) width
                          + a gap l
                          dec step
      :ns $ quote
        ns app.comp.blow $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/blow.wgsl" :default wgsl-blow
          lagopus.comp.curves :refer $ comp-curves
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
          "\"@calcit/std" :refer $ rand rand-shift
    |app.comp.container $ {}
      :defs $ {}
        |comp-container $ quote
          defn comp-container (store)
            let
                states $ :states store
                show? $ :show-tabs? store
              group nil
                if
                  and (not hide-tabs?) show?
                  memof1-call comp-tabs
                case-default (:tab store)
                  do
                    js/console.log "\"Unknown tab" $ :tab store
                    group nil
                  :cube $ comp-cubes
                  :helicoid $ comp-helicoid
                  :hyperbolic-helicoid $ comp-hyperbolic-helicoid (>> states :hh)
                  :globe $ comp-globe
                  :fur $ comp-fur
                  :petal-wireframe $ comp-petal-wireframe
                  :mums $ comp-mums
                  :flower-ball $ with-cpu-time (comp-flower-ball)
                  :blow $ comp-blow
                  :triangles $ comp-triangles
                  :segments $ comp-segments-fractal
                  :quaternion-fold $ comp-quaternion-fold
                  :hopf $ comp-hopf-fiber (>> states :hopf) show?
                  :fireworks $ comp-fireworks
        |comp-fur $ quote
          defn comp-fur () $ comp-curves
            {} (:shader wgsl-fur)
              :curves $ -> (range 200)
                map $ fn (idx)
                  let
                      radian $ * 0.2 idx
                      r $ * 0.8 (sqrt idx)
                      base $ []
                        * r $ cos radian 
                        , 0
                          * r $ sin radian 
                    -> (range 100)
                      map $ fn (hi)
                        {}
                          :position $ v+ base
                            [] 0 (* 2 hi) 0
                          :width 0.6
        |comp-tabs $ quote
          defn comp-tabs () $ group nil
            comp-button
              {}
                :position $ [] 0 200 0
                :color $ [] 0.3 0.9 0.2 1
                :size 20
              fn (e d!)
                d! $ : tab :cube
            comp-button
              {}
                :position $ [] 40 200 0
                :color $ [] 0.8 0.3 1 1
                :size 20
              fn (e d!)
                d! $ : tab :helicoid
            comp-button
              {}
                :position $ [] 80 200 0
                :color $ [] 0.6 0.3 1 1
                :size 20
              fn (e d!)
                d! $ : tab :hyperbolic-helicoid
            comp-button
              {}
                :position $ [] 120 200 0
                :color $ [] 0.3 0.9 0.5 1
                :size 20
              fn (e d!)
                d! $ : tab :globe
            comp-button
              {}
                :position $ [] 160 200 0
                :color $ [] 0.9 0.5 0.6 1
                :size 20
              fn (e d!)
                d! $ : tab :fur
            comp-button
              {}
                :position $ [] 200 200 0
                :color $ [] 0.0 0.5 0.6 1
                :size 20
              fn (e d!)
                d! $ : tab :petal-wireframe
            comp-button
              {}
                :position $ [] 240 200 0
                :color $ [] 0.9 0.5 0.6 1
                :size 20
              fn (e d!)
                d! $ : tab :mums
            comp-button
              {}
                :position $ [] 280 200 0
                :color $ [] 0.3 0.9 0.3 1
                :size 20
              fn (e d!)
                d! $ : tab :flower-ball
            comp-button
              {}
                :position $ [] 320 200 0
                :color $ [] 0.4 0.9 0.6 1
                :size 20
              fn (e d!)
                d! $ : tab :blow
            comp-button
              {}
                :position $ [] 360 200 0
                :color $ [] 0.8 0.3 0.6 1
                :size 20
              fn (e d!)
                d! $ : tab :triangles
            comp-button
              {}
                :position $ [] 400 200 0
                :color $ [] 0.2 0.6 0.6 1
                :size 20
              fn (e d!)
                d! $ : tab :segments
            comp-button
              {}
                :position $ [] 440 200 0
                :color $ [] 0.8 0.6 0.6 1
                :size 20
              fn (e d!)
                d! $ : tab :quaternion-fold
            comp-button
              {}
                :position $ [] 480 200 0
                :color $ [] 0.2 0.6 0.9 1
                :size 20
              fn (e d!)
                d! $ : tab :hopf
            comp-button
              {}
                :position $ [] 480 160 0
                :color $ [] 0.5 0.8 0.4 1
                :size 20
              fn (e d!)
                d! $ : tab :fireworks
      :ns $ quote
        ns app.comp.container $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/cube.wgsl" :default cube-wgsl
          "\"../shaders/fur.wgsl" :default wgsl-fur
          lagopus.comp.button :refer $ comp-button
          lagopus.comp.curves :refer $ comp-curves
          lagopus.comp.spots :refer $ comp-spots
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          app.comp.cube-combo :refer $ comp-cubes
          app.config :refer $ hide-tabs?
          app.comp.helicoid :refer $ comp-helicoid comp-hyperbolic-helicoid
          app.comp.globe :refer $ comp-globe
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
          app.comp.mums :refer $ comp-mums
          app.comp.patels :refer $ comp-petal-wireframe
          app.comp.flower-ball :refer $ comp-flower-ball
          app.comp.blow :refer $ comp-blow
          app.comp.triangles :refer $ comp-triangles
          app.comp.segments-fractal :refer $ comp-segments-fractal
          app.comp.quaterion-fold :refer $ comp-quaternion-fold
          app.comp.hopf-fiber :refer $ comp-hopf-fiber
          app.comp.fireworks :refer $ comp-fireworks
    |app.comp.cube-combo $ {}
      :defs $ {}
        |comp-cubes $ quote
          defn comp-cubes () $ let
              cube-count 60
            object $ {} (:shader cube-combo-wgsl)
              :topology $ do :line-strip :triangle-list
              :attrs-list $ [] (:: :float32x3 :position) (:: :float32x3 :metrics) (:: :uint32 :idx) (:: :float32x3 :offsets)
              :data $ -> (range cube-count)
                map $ fn (idx)
                  let
                      area 460
                      base $ [] (rand-shift 0 area) (rand-shift 0 area) (rand-shift 0 area)
                      size-bound 80
                      offsets $ []
                        + 10 $ rand size-bound
                        + 10 $ rand size-bound
                        + 10 $ rand size-bound
                    []
                      {} (:idx idx) (:offsets offsets)
                        :metrics $ [] -1 -1 1
                        :position $ v+ base
                          -> offsets (update 0 negate) (update 1 negate)
                      {} (:idx idx) (:offsets offsets)
                        :metrics $ [] 1 -1 1
                        :position $ v+ base
                          -> offsets $ update 1 negate
                      {} (:idx idx) (:offsets offsets)
                        :metrics $ [] 1 -1 -1
                        :position $ v+ base
                          -> offsets (update 1 negate) (update 2 negate)
                      {} (:idx idx) (:offsets offsets)
                        :metrics $ [] -1 -1 -1
                        :position $ v+ base
                          -> offsets (update 0 negate) (update 1 negate) (update 2 negate)
                      {} (:idx idx) (:offsets offsets)
                        :metrics $ [] -1 1 1
                        :position $ v+ base
                          -> offsets $ update 0 negate
                      {} (:idx idx) (:offsets offsets)
                        :metrics $ [] 1 1 1
                        :position $ v+ base offsets
                      {} (:idx idx) (:offsets offsets)
                        :metrics $ [] 1 1 -1
                        :position $ v+ base
                          -> offsets $ update 2 negate
                      {} (:idx idx) (:offsets offsets)
                        :metrics $ [] -1 1 -1
                        :position $ v+ base
                          -> offsets (update 0 negate) (update 2 negate)
              :indices $ let
                  indices $ concat &
                    [] ([] 0 1 2 0 2 3 ) ([] 0 1 5 0 4 5) ([] 1 2 6 1 6 5) ([] 2 3 6 3 6 7) ([] 0 3 4 3 4 7) ([] 4 5 6 4 6 7)
                -> (range cube-count)
                  map $ fn (idx)
                    -> indices $ map
                      fn (x)
                        + x $ * 8 idx
      :ns $ quote
        ns app.comp.cube-combo $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/cube-combo.wgsl" :default cube-combo-wgsl
          lagopus.comp.button :refer $ comp-button
          lagopus.comp.curves :refer $ comp-curves
          lagopus.comp.spots :refer $ comp-spots
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+
          "\"@calcit/std" :refer $ rand rand-shift
    |app.comp.fireworks $ {}
      :defs $ {}
        |comp-fireworks $ quote
          defn comp-fireworks () $ group nil
            comp-polylines-marked $ {} (:shader wgsl-fireworks)
              :writer $ fn (write!)
                -> (range 2000)
                  each $ fn (_)
                    let
                        base $ [] (rand-shift 0 20000) (rand-shift 0 2080) (rand-shift 0 20000)
                        color $ rand 10
                        w $ + 2 (rand 6)
                      ->
                        fibo-grid-range $ rand-int 40 400
                        each $ fn (v)
                          let
                              a1 $ rand 4
                              a2 $ rand 4
                            ->
                              range $ rand-int 12
                              map $ fn (n)
                                * 1 $ + n 3 a2
                              each $ fn (n)
                                let
                                    t $ * 2.2 n
                                    p $ v+ base
                                      v-scale v $ * 6 t a1
                                      v-scale ([] 0 -0.4 0) (* t t 0.5)
                                  write! $ : vertex (v-scale p 1) w color
                          write! break-mark
      :ns $ quote
        ns app.comp.fireworks $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/fireworks.wgsl" :default wgsl-fireworks
          lagopus.comp.curves :refer $ comp-curves comp-polylines comp-polylines-marked break-mark
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          app.config :refer $ hide-tabs?
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
          "\"@calcit/std" :refer $ rand rand-int rand-shift rand-between
    |app.comp.flower-ball $ {}
      :defs $ {}
        |build-umbrella $ quote
          defn build-umbrella (p0 v0 relative parts elevation decay step write!)
            if (&> step 0)
              let
                  l0 $ v-length v0
                  forward $ v-scale v0 (&/ 1 l0)
                  rightward $ v-normalize (v-cross v0 relative)
                  upward $ v-cross rightward forward
                  line0 $ v-scale
                    &v+
                      v-scale forward $ cos elevation
                      v-scale upward $ sin elevation
                    &* l0 decay
                  p-next $ &v+ p0 v0
                  theta0 $ &/ (&* 2 &PI) parts
                  lines $ -> (range parts)
                    map $ fn (idx)
                      rotate-3d v-zero forward (&* theta0 idx) line0 
                  width 0.2
                write! $ [] (: vertex p0 width)
                  : vertex (&v+ p0 v0) width
                  , break-mark
                -> lines $ map
                  fn (line)
                    build-umbrella p-next line v0 parts elevation decay (dec step) write!
        |comp-flower-ball $ quote
          defn comp-flower-ball () $ let
              origin $ [] 0 0 0
              parts 8
              elevation $ * &PI 0.5
              decay 0.36
              iteration 8
              unit 800
            ; js/console.log $ .flatten ps
            comp-polylines $ {} (:shader wgsl-flower-ball)
              :writer $ fn (write!)
                ->
                  []
                    [] ([] 0 unit 0) ([] 0 0 1)
                    []
                      [] 0 (negate unit) 0
                      [] 0 0 1
                    [] ([] unit 0 0) ([] 0 1 0)
                    []
                      [] (negate unit) 0 0
                      [] 0 1 0
                    [] ([] 0 0 unit) ([] 0 1 0)
                    []
                      [] 0 0 $ negate unit
                      [] 0 1 0
                  take 1
                  map $ fn (pair)
                    build-umbrella origin (nth pair 0) (nth pair 1) parts elevation decay iteration write!
        |v-zero $ quote
          def v-zero $ [] 0 0 0
      :ns $ quote
        ns app.comp.flower-ball $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/flower-ball.wgsl" :default wgsl-flower-ball
          lagopus.comp.curves :refer $ comp-curves comp-polylines break-mark
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          app.config :refer $ hide-tabs?
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
    |app.comp.globe $ {}
      :defs $ {}
        |comp-globe $ quote
          defn comp-globe () $ comp-sphere
            {} (; :topology :line-strip) (:shader wgsl-globe) (:iteration 7) (:radius 1800)
              :color $ [] 0.6 0.9 0.7
        |wgsl-globe $ quote
          def wgsl-globe $ inline-shader "\"globe"
      :ns $ quote
        ns app.comp.globe $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/cube-combo.wgsl" :default cube-combo-wgsl
          lagopus.comp.button :refer $ comp-button
          lagopus.comp.curves :refer $ comp-curves
          lagopus.comp.spots :refer $ comp-spots
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+
          "\"@calcit/std" :refer $ rand rand-shift
          lagopus.comp.sphere :refer $ comp-sphere
          app.config :refer $ inline-shader
    |app.comp.helicoid $ {}
      :defs $ {}
        |build-01-grid $ quote
          defn build-01-grid (size s)
            -> (range-bothway size)
              map $ fn (x)
                -> (range-bothway size)
                  map $ fn (y)
                    let
                        r $ * s (&/ 1 size)
                        p0 $ [] (* r x) (* r y)
                        p1 $ []
                          * r $ inc x
                          * r y
                        p2 $ [] (* r x)
                          * r $ inc y
                        p3 $ []
                          * r $ inc x
                          * r $ inc y
                      [] (&{} :position p0) (&{} :position p1) (&{} :position p2) (&{} :position p1) (&{} :position p2) (&{} :position p3)
        |comp-helicoid $ quote
          defn comp-helicoid () $ comp-plate
            {} (; :topology :line-strip)
              :shader $ inline-shader "\"helicoid"
              :iteration 120
              :radius 160
              :color $ [] 0.56 0.8 0.84
              ; :x-direction $ [] 1 0 0
              ; :y-direction $ [] 0 1 0
              :chromatism 0.14
        |comp-hyperbolic-helicoid $ quote
          defn comp-hyperbolic-helicoid (states)
            let
                cursor $ :cursor states
                state $ either (:data states)
                  {} $ :tau 4.0
                tau $ :tau state
              group nil
                object $ {} (:shader hyperbolic-helicoid-wgsl)
                  :topology $ do :triangle-list :line-strip
                  :attrs-list $ [] (:: :float32x2 :position)
                  :data $ build-01-grid 80 6
                  :add-uniform $ fn () (js-array tau 0 0 0)
                comp-slider
                  {}
                    :position $ [] 0 240 0
                    :size 12
                    :color $ [] 0.7 0.6 0.5 1.0
                  fn (delta d!)
                    d! $ : state cursor
                      assoc state :tau $ + tau
                        * 0.01 $ nth delta 0
      :ns $ quote
        ns app.comp.helicoid $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/hyperbolic-helicoid.wgsl" :default hyperbolic-helicoid-wgsl
          lagopus.comp.button :refer $ comp-button comp-slider
          lagopus.comp.curves :refer $ comp-curves
          lagopus.comp.spots :refer $ comp-spots
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+
          "\"@calcit/std" :refer $ rand rand-shift
          lagopus.comp.plate :refer $ comp-plate
          app.config :refer $ inline-shader
    |app.comp.hopf-fiber $ {}
      :defs $ {}
        |calc-k $ quote
          defn calc-k (p0 p1)
            let
                x0 $ nth p0 0
                z0 $ nth p0 2
                x1 $ nth p1 0
                y1 $ nth p1 1
                z1 $ nth p1 2
              * 0.5 $ &/
                - (v-length2 p1) (v-length2 p0)
                + (* x0 x1) (* z0 z1)
                  negate $ v-length2 p0
        |comp-hopf-fiber $ quote
          defn comp-hopf-fiber (states show?)
            let
                cursor $ :cursor states
                state $ either (:data states)
                  {} $ :base ([] 90 8 4)
                base $ :base state
                rh $ v-normalize
                  v-cross base $ [] 0 1 0
                rv $ v-normalize (v-cross rh base)
              group nil
                if show? $ comp-axis
                if show? $ comp-drag-point
                  {}
                    :position $ :base state
                    :color $ [] 0.6 0.6 1.0 1.0
                  fn (move d!)
                    d! $ : :state cursor (assoc state :base move)
                comp-polylines-marked $ {} (:shader wgsl-hopf)
                  :writer $ fn (write!)
                    -> (range 16)
                      map $ fn (ring-idx)
                        let
                            circle-size 60
                          ->
                            range $ inc circle-size
                            map $ fn (idx)
                              let
                                  alpha $ * 0.2 (+ 0.2 ring-idx)
                                  start $ v-scale base (cos alpha)
                                  l $ * (v-length base) (sin alpha)
                                  rh1 $ v-scale rh l
                                  rv1 $ v-scale rv l
                                  theta $ * 2 0.333 idx (/ &PI circle-size)
                                  p $ v+ start
                                    v-scale rh1 $ cos theta
                                    v-scale rv1 $ sin theta
                                if show? $ write! (: vertex p 1 1)
                                , p
                            map-indexed $ fn (i control)
                              let
                                  circle $ decide-circle control
                                  n 80
                                ->
                                  range $ inc n
                                  map $ fn (idx)
                                    let
                                        ratio $ * 2 idx (/ &PI n)
                                      tag-match circle
                                          :circle center rh rv
                                          do nil $ write!
                                            : vertex
                                              v-scale
                                                v+ center
                                                  v-scale rh $ cos ratio
                                                  v-scale rv $ sin ratio
                                                , 200
                                              * 0.8 $ pow ring-idx 0.4
                                              , ring-idx
                                        _ $ eprintln "\"unknown data:" circle
                                write! break-mark
        |decide-circle $ quote
          defn decide-circle (v0)
            let
                p1 $ v-normalize v0
                c1 $ [] (nth p1 0) (nth p1 2)
                theta $ js/Math.atan2 (nth p1 2) (nth p1 0)
                theta0 $ &- theta (* 0.5 &PI)
                p0 $ [] (nth p1 2) 0
                  negate $ nth p1 0
                k $ calc-k p0 p1
                center $ v-scale p0 k
                rh $ v- p0 center
                v1 $ v-cross rh (v- p1 center)
                rv $ v-scale
                  v-normalize $ v-cross v1 rh
                  v-length rh
              : circle center rh rv
        |v-length2 $ quote
          defn v-length2 (a)
            let-sugar
                  [] x y z
                  , a
              -> (&* x x)
                &+ $ &* y y
                &+ $ &* z z
      :ns $ quote
        ns app.comp.hopf-fiber $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/hopf.wgsl" :default wgsl-hopf
          lagopus.comp.curves :refer $ comp-curves comp-polylines comp-polylines-marked break-mark comp-axis
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v- v-normalize v-cross v-normalize
          app.config :refer $ hide-tabs?
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
          lagopus.comp.button :refer $ comp-drag-point
    |app.comp.mums $ {}
      :defs $ {}
        |comp-mums $ quote
          defn comp-mums () $ let
              points $ fibo-grid-range 400
            comp-curves $ {} (:shader wgsl-mums)
              :curves $ -> points
                map $ fn (p)
                  let
                      v $ v-scale p
                        * 2
                          pow
                            v-length $ assoc p 1 0
                            , 3
                          + 0.3 $ js/Math.random
                      path $ roll-curve v
                        v-normalize $ v-cross ([] 0 1 0) v
                        / 0.03 $ pow (v-length v) 2
                    ; js/console.log path
                    -> path $ map
                      fn (p2)
                        {} (:position p2) (:width 2)
        |roll-curve $ quote
          defn roll-curve (v0 axis0 delta)
            let
                steps 80
                dt 2
                p0 $ [] 0 0 0
                ad $ [] (js/Math.random) (js/Math.random) (js/Math.random)
              apply-args
                  []
                  , p0 v0 axis0 0
                fn (acc position v axis s)
                  if (&>= s steps) (conj acc position)
                    let
                        v-next $ rotate-3d ([] 0 0 0) axis
                          -
                            pow (&* s delta) 7
                            , 0.008
                          , v
                        axis-next $ rotate-3d ([] 0 0 0) ad
                          pow (&* s 0.011) 8
                          , axis
                        next $ &v+ position (v-scale v dt)
                      recur (conj acc position) next v-next axis-next (inc s) 
      :ns $ quote
        ns app.comp.mums $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/mums.wgsl" :default wgsl-mums
          lagopus.comp.curves :refer $ comp-curves
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
    |app.comp.patels $ {}
      :defs $ {}
        |build-quadratic-curve $ quote
          defn build-quadratic-curve (p q step gravity)
            let
                v $ &v- q p
                l $ v-length v
                dd $ &/ l step
                size $ js/Math.floor dd
                left $ &* 0.5
                  - l $ &* size step
                unit $ v-normalize v
                dist $ ->
                  range $ inc size
                  map $ fn (idx)
                    + left $ * idx step
                l-middle $ * 0.25 l l
              -> dist $ map
                fn (ratio)
                  let
                      s $ js/Math.abs
                        &- ratio $ &* 0.5 l
                    &v+
                      &v+ p $ v-scale unit ratio
                      v-scale gravity $ &- l-middle (pow s 2)
        |comp-petal-wireframe $ quote
          defn comp-petal-wireframe () $ let
              large-frame $ fibo-grid-range 48
              small-frame $ fibo-grid-range 12
              lines $ -> large-frame
                mapcat $ fn (x)
                  map small-frame $ fn (y) ([] x y)
            comp-curves $ {} (:shader wgsl-petal-wireframe)
              :curves $ -> lines
                map $ fn (pair)
                  let
                      from $ nth pair 0
                      to $ nth pair 1
                      points $ build-quadratic-curve
                        v-scale
                          update from 1 $ fn (y) (* 0.4 y)
                          , 400
                        v-scale
                          update to 1 $ fn (y)
                            - (* 0.4 y) 0.5
                          , 180
                        , 16 ([] 0 -0.0016 0)
                    map points $ fn (p)
                      {} (:position p) (:width 1.)
      :ns $ quote
        ns app.comp.patels $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/petal-wireframe.wgsl" :default wgsl-petal-wireframe
          lagopus.comp.curves :refer $ comp-curves
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          app.config :refer $ hide-tabs?
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
    |app.comp.quaterion-fold $ {}
      :defs $ {}
        |comp-quaternion-fold $ quote
          defn comp-quaternion-fold () $ let ()
            with-cpu-time $ object-writer
              {} (:topology :line-strip) (:shader wgsl-quaternion-fold)
                :attrs-list $ [] (: float32x3 :position)
                :writer $ fn (write!)
                  ; fold-line4 19 ([] 0 0 0 0) ([] 0 100 0 0) ([] 0 20 0 22) ([] 16 20 0 23) ([] 16 20 0 27) ([] 0 20 0 28)
                    q-inverse $ [] 0 0 0 50
                    , 0.0027 write!
                  fold-line4 12 ([] 0 0 0 0) ([] 200 0 0 0) ([] 0 20 0 25) ([] 5 20 10 25) ([] 5 20 10 15) ([] 0 20 0 15)
                    q-inverse $ [] 0 0 0 50
                    , 0.1 write!
        |fold-line4 $ quote
          defn fold-line4 (level base v a b c d full' minimal-seg write!)
            let
                v' $ &q* v full'
                branch-a $ &q* v' a
                branch-b $ &q* v' b
                branch-c $ &q* v' c
                branch-d $ &q* v' d
                s 10
                dec-level $ &- level 1
              if
                or (&<= level 0)
                  &< (q-length2 v) minimal-seg
                write! $ []
                  : vertex $ take3 (&q+ base branch-b) 20
                  : vertex $ take3 (&q+ base branch-b) 20
                  : vertex $ take3 (&q+ base branch-c) 20
                  : vertex $ take3 (&q+ base branch-d) 20
                  : vertex $ take3 (&q+ base v) 20
                do (fold-line4 dec-level base branch-a a b c d full' minimal-seg write!)
                  fold-line4 dec-level (&q+ base branch-a) (&q- branch-b branch-a) a b c d full' minimal-seg write!
                  fold-line4 dec-level (&q+ base branch-b) (&q- branch-c branch-b) a b c d full' minimal-seg write!
                  fold-line4 dec-level (&q+ base branch-c) (&q- branch-d branch-c) a b c d full' minimal-seg write!
                  fold-line4 dec-level (&q+ base branch-d) (&q- v branch-d) a b c d full' minimal-seg write!
        |take3 $ quote
          defn take3 (v s)
            []
              &* s $ &list:nth v 0
              &* s $ &list:nth v 1
              &* s $ &list:nth v 2
      :ns $ quote
        ns app.comp.quaterion-fold $ :require
          lagopus.alias :refer $ group object object-writer
          "\"../shaders/petal-wireframe.wgsl" :default wgsl-petal-wireframe
          lagopus.comp.curves :refer $ comp-polylines break-mark
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          app.config :refer $ hide-tabs?
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
          quaternion.core :refer $ &q* &q+ &q- q-length2 q-inverse
          "\"../shaders/quaternion-fold.wgsl" :default wgsl-quaternion-fold
    |app.comp.segments-fractal $ {}
      :defs $ {}
        |comp-segments-fractal $ quote
          defn comp-segments-fractal () $ let
              p1 $ [] 0.46 0.01 0
              p2 $ [] 0.48 0.4 0.1
              p3 $ [] 0.5 0.0 0
              p4 $ [] 0.52 0.4 0.1
              p5 $ [] 0.54 0.01 0
              level 7
              target $ [] 1000 0 0
            comp-polylines $ {} (; :shader wgsl-flower-ball)
              :writer $ fn (write!)
                write! $ []
                  : vertex ([] 0 0 0) 4
                  : vertex target 4
                  , break-mark
                fold-fractal ([] 0 0 0) target ([] 0 0 1) p1 p2 p3 p4 p5 level write!
        |fold-fractal $ quote
          defn fold-fractal (base target right p1 p2 p3 p4 p5 level write!)
            let
                w $ / 0.5 (pow level 1.6)
                next $ &v- target base
                forward $ v-normalize next
                upward $ v-cross right forward
                l $ v-length next
                point1 $ &v+ base
                  v-scale
                    v+
                      v-scale forward $ nth p1 0
                      v-scale upward $ nth p1 1
                      v-scale right $ nth p1 2
                    , l
                point2 $ &v+ base
                  v-scale
                    v+
                      v-scale forward $ nth p2 0
                      v-scale upward $ nth p2 1
                      v-scale right $ nth p2 2
                    , l
                point3 $ &v+ base
                  v-scale
                    v+
                      v-scale forward $ nth p3 0
                      v-scale upward $ nth p3 1
                      v-scale right $ nth p3 2
                    , l
                point4 $ &v+ base
                  v-scale
                    v+
                      v-scale forward $ nth p4 0
                      v-scale upward $ nth p4 1
                      v-scale right $ nth p4 2
                    , l
                point5 $ &v+ base
                  v-scale
                    v+
                      v-scale forward $ nth p5 0
                      v-scale upward $ nth p5 1
                      v-scale right $ nth p5 2
                    , l
                m $ middle base target
              if (&> level 1)
                do nil
                  ; write! $ [] (: vertex base w) (: vertex point1 w) (: vertex point2 w) (: vertex point3 w) (: vertex point4 w) (: vertex target w) break-mark
                  let
                      right1 $ v-normalize
                        safe-right
                          v-cross (&v- point1 base)
                            &v- (middle base point1) m
                          , right
                    fold-fractal base point1 right1 p1 p2 p3 p4 p5 (dec level) write!
                  let
                      right2 $ v-normalize
                        safe-right
                          v-cross (&v- point2 point1)
                            &v- (middle point1 point2) m
                          , right
                    fold-fractal point1 point2 right2 p1 p2 p3 p4 p5 (dec level) write!
                  let
                      right3 $ v-normalize
                        safe-right
                          v-cross (&v- point3 point2)
                            &v- (middle point2 point3) m
                          , right
                    fold-fractal point2 point3 right3 p1 p2 p3 p4 p5 (dec level) write!
                  let
                      right4 $ v-normalize
                        safe-right
                          v-cross (&v- point4 point3)
                            &v- (middle point3 point4) m
                          , right
                    fold-fractal point3 point4 right4 p1 p2 p3 p4 p5 (dec level) write!
                  let
                      right5 $ v-normalize
                        safe-right
                          v-cross (&v- point4 point4)
                            &v- (middle point4 point5) m
                          , right
                    fold-fractal point4 target right5 p1 p2 p3 p4 p5 (dec level) write!
                  let
                      right6 $ v-normalize
                        safe-right
                          v-cross (&v- target point5)
                            &v- (middle point5 target) m
                          , right
                    fold-fractal point4 target right6 p1 p2 p3 p4 p5 (dec level) write!
                write! $ [] (: vertex base w) (: vertex point1 w) (: vertex point2 w) (: vertex point3 w) (: vertex point4 w) (: vertex point5 w) (: vertex target w) break-mark
        |middle $ quote
          defn middle (base target)
            v-scale (&v+ base target) 0.5
        |safe-right $ quote
          defn safe-right (v right)
            if
              &= 0 $ v-length v
              , right v
      :ns $ quote
        ns app.comp.segments-fractal $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/petal-wireframe.wgsl" :default wgsl-petal-wireframe
          lagopus.comp.curves :refer $ comp-polylines break-mark
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          app.config :refer $ hide-tabs?
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
    |app.comp.triangles $ {}
      :defs $ {}
        |build-sierpinski-triangles $ quote
          defn build-sierpinski-triangles (p1 p2 p3 p4 level w dup? write!)
            write! $ if dup?
              [] (: vertex p2 w) (: vertex p3 w) (: vertex p4 w) (: vertex p2 w) break-mark
              [] (: vertex p1 w) (: vertex p2 w) (: vertex p3 w) (: vertex p4 w) (: vertex p2 w) break-mark (: vertex p4 w) (: vertex p1 w) (: vertex p3 w) break-mark
            if (&> level 0)
              let
                  p1-2 $ v-scale (&v+ p1 p2) 0.5
                  p1-3 $ v-scale (&v+ p1 p3) 0.5
                  p1-4 $ v-scale (&v+ p1 p4) 0.5
                  p2-3 $ v-scale (&v+ p2 p3) 0.5
                  p2-4 $ v-scale (&v+ p2 p4) 0.5
                  p3-4 $ v-scale (&v+ p3 p4) 0.5
                  p-all $ &v+
                    &v+ p1 $ &v+ p2 p3
                    , p4
                  p-04 $ v-scale (&v- p-all p4) third
                  p-03 $ v-scale (&v- p-all p3) third
                  p-02 $ v-scale (&v- p-all p2) third
                  p-01 $ v-scale (&v- p-all p1) third
                if
                  > (js/Math.random) 0.1
                  build-sierpinski-triangles p1 p1-2 p1-3 p1-4 (dec level) w true write!
                build-sierpinski-triangles p2 p1-2 p2-3 p2-4 (dec level) w true write!
                build-sierpinski-triangles p3 p1-3 p2-3 p3-4 (dec level) w true write!
                build-sierpinski-triangles p4 p1-4 p2-4 p3-4 (dec level) w true write!
                ; build-sierpinski-triangles p-01 p-02 p-03 p-04 (dec level) w false write!
        |comp-triangles $ quote
          defn comp-triangles () $ let ()
            comp-polylines $ {} (:shader wgsl-triangles)
              :writer $ fn (write!)
                build-sierpinski-triangles ([] 1000 0 0) ([] -500 0 -800) ([] -500 0 800) ([] 0 1200 0) 10 0.1 false write!
        |third $ quote
          def third $ &/ 1 3
      :ns $ quote
        ns app.comp.triangles $ :require
          lagopus.alias :refer $ group object
          "\"../shaders/triangles.wgsl" :default wgsl-triangles
          lagopus.comp.curves :refer $ comp-curves comp-polylines break-mark
          memof.once :refer $ memof1-call
          quaternion.core :refer $ c+ v+ &v+ v-scale v-length &v- v-normalize v-cross
          app.config :refer $ hide-tabs?
          lagopus.cursor :refer $ >>
          lagopus.math :refer $ fibo-grid-range rotate-3d
    |app.config $ {}
      :defs $ {}
        |bloom? $ quote
          def bloom? $ = "\"true" (get-env "\"bloom" "\"false")
        |dev? $ quote
          def dev? $ &= "\"dev" (get-env "\"mode" "\"release")
        |hide-tabs? $ quote
          def hide-tabs? $ = "\"true" (get-env "\"hide-tabs" "\"false")
        |inline-shader $ quote
          defmacro inline-shader (path)
            read-file $ str "\"shaders/" path "\".wgsl"
        |mobile-info $ quote
          def mobile-info $ ismobile js/window.navigator
        |remote-control? $ quote
          def remote-control? $ get-env "\"remote-control" nil
      :ns $ quote
        ns app.config $ :require ("\"ismobilejs" :default ismobile)
    |app.main $ {}
      :defs $ {}
        |*store $ quote
          defatom *store $ {}
            :states $ {}
            :tab :fireworks
            :show-tabs? false
            :show-controls? true
        |canvas $ quote
          def canvas $ js/document.querySelector "\"canvas"
        |dispatch! $ quote
          defn dispatch! (op)
            if dev? $ js/console.log op
            let
                store @*store
                next-store $ updater store op
              if (not= next-store store) (reset! *store next-store)
        |main! $ quote
          defn main! () (hint-fn async)
            if
              and bloom? $ not (.-any mobile-info)
              enableBloom
            if dev? $ load-console-formatter!
            js-await $ initializeContext
            initializeCanvasTextures
            reset-clear-color! $ either bg-color
              {} (:r 0.04) (:g 0) (:b 0.1) (:a 0.98)
            render-app!
            renderControl
            startControlLoop 10 onControlEvent
            registerShaderResult handle-compilation
            set! js/window.onresize $ fn (e) (resetCanvasSize canvas) (initializeCanvasTextures) (paintLagopusTree)
            resetCanvasSize canvas
            add-watch *store :change $ fn (next store) (render-app!)
            setupMouseEvents canvas
            if remote-control? $ setupRemoteControl
              fn (action)
                case-default (.-button action) (js/console.warn "\"Unknown Action" action)
                  "\"toggle" $ dispatch! (: toggle)
                  "\"switch" $ dispatch! (: switch)
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (reset-memof1-caches!) (render-app!) (remove-watch *store :change)
              add-watch *store :change $ fn (next store) (render-app!)
              println "\"Reloaded."
              hud! "\"ok~" "\"OK"
            hud! "\"error" build-errors
        |render-app! $ quote
          defn render-app! () $ let
              tree $ comp-container @*store
            renderLagopusTree tree dispatch!
      :ns $ quote
        ns app.main $ :require
          app.comp.container :refer $ comp-container
          "\"@triadica/lagopus" :refer $ setupMouseEvents onControlEvent paintLagopusTree renderLagopusTree initializeContext resetCanvasSize initializeCanvasTextures registerShaderResult enableBloom
          "\"@triadica/touch-control" :refer $ renderControl startControlLoop
          lagopus.config :refer $ bg-color
          app.config :refer $ dev? mobile-info bloom? remote-control?
          "\"bottom-tip" :default hud!
          "\"./calcit.build-errors" :default build-errors
          memof.once :refer $ reset-memof1-caches!
          lagopus.util :refer $ handle-compilation reset-clear-color!
          app.updater :refer $ updater
          "\"@triadica/lagopus/lib/remote-control.mjs" :refer $ setupRemoteControl
    |app.updater $ {}
      :defs $ {}
        |updater $ quote
          defn updater (store op)
            tag-match op
                :state c s
                update-states store c s
              (:tab t) (assoc store :tab t)
              (:tau t) (assoc store :tau t)
              (:toggle) (update store :show-tabs? not)
              _ $ do (js/console.warn "\"Unknown op:" op) store
      :ns $ quote
        ns app.updater $ :require
          lagopus.cursor :refer $ update-states
    |app.util $ {}
      :defs $ {}
        |interoplate-line $ quote
          defn interoplate-line (from to n)
            ->
              range $ inc n
              map $ fn (i)
                let
                    a $ / i n
                    b $ - 1 a
                  v+ (v-scale from a) (v-scale to b)
      :ns $ quote (ns app.util)
