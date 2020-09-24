local c = {}

c.speed = 600
c.scaleSpeed = 0.25
c.keyboardScaleSpeed = 10
c.minZoom = 0.1
c.maxZoom = 3
c.initialTranslation = {x=0, y=0}
c.initialScale = 1

c.mouseMovement = false
c.mouseMovementMargin = 10 -- area where the cursor moves the camera

-- Steering
c.left    = 'a'
c.right   = 'd'
c.up      = 'w'
c.down    = 's'
c.zoomin  = '='
c.zoomout = '-'

return c