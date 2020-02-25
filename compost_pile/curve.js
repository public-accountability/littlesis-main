//(Node, Node) --> Node
function leftNode(a, b) {
  if (a.x <= b.x) {
    return a
  } else {
    return b
  }
}

function rightNode(a, b) {
  if (leftNode(a, b).id === a.id) {
    return b
  } else {
    return a
  }
}



// Node, Node, Number ---> { x: number, y: number }
export function defaultOffset(leftNode, rightNode, curveStrength = 0.5) {
  const midP = midpoint(leftNode, rightNode)
  const x = -(leftNode.display.y - midP.y)
  const y = leftNode.display.x  - midP.x

  return mapValues({ x, y }, n => n * curveStrength)
}

export function defaultControlPoint(node1, node2) {
  const nodeL = leftNode(node1, node2)
  const nodeR = rightNode(node1, node2)
  const midP = midpoint(nodeL, nodeR)
  const offset = defaultOffset(nodeL, nodeR)

  return { x: midP.x + offset.x,
           y: midP.y + offset.y }

}

export function curveString(p1, p2, p3) {
  return `M ${p1.x} ${p1.y} Q ${p2.x} ${p2.y} ${p3.x} ${p3.y}`
}


/*
  Creates a curve string used by the <path> element to draw edges
  The curve is a Quadratic Bezier curve.
  It takes 3 points (p1, p2, p3) to draw the curve. We also refer to p2 as the "control" point.

  See the documentation on Q paths here: https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Paths

  node1 and node2 are required. If the control point is not provided a default value will be calculated.
*/
export function calculateCurve(node1, node2) {
  const p1 = xy(leftNode(node1, node2).display)
  const p2 = defaultControlPoint(node1, node2)
  const p3 = xy(rightNode(node1, node2).display)
  return curveString(p1, p2, p3)
}

// function angleBetweenPoints(a, b) {
//   return Math.atan2(b.y - a.y, b.x - a.x)
// }

// function rotatePoint(point, angle) {
//   const cos = Math.cos(angle)
//   const sin = Math.sin(angle)

//   return { x: point.x * cos - point.y * sin,
//            y: point.x * sin + point.y * cos }
// }

// export function moveCurvePoint(curveString, side, deltas) {
//   const curve = parseCurveString(curveString).map(xyFromArray)
//   const futureCurve = clone(curve)

//   if (side === 'START') {
//     futureCurve[0] = translatePoint(curve[0], deltas)
//   } else {
//     futureCurve[2] = translatePoint(curve[2], deltas)
//   } It's fine so far. They have lots of extra space in their office so I'm basically just working away like a I always do...



//   const deltaAngle = angleBetweenPoints(futureCurve[0], futureCurve[2]) - angleBetweenPoints(curve[0], curve[2])

//   futureCurve[1] = rotatePoint(curve[1], deltaAngle)

//   return curveString(...futureCurve)

// }

// `start` and `end`` are arrays: [x, y]
export function midpoint(start, end) {
  let [x1, y1] = start
  let [x2, y2] = end
  let midX = (x1 + x2) / 2
  let midY = (y1 + y2) / 2
  return [midX, midY]
}


function slope(point1, point2) {
  return (point2.y - point1.y) / (point2.x - point1.x)
}

function yIntercept(point, slope) {
  return point.y - (slope * point.x)
}

function lineBetween(point1, point2) {
  let m = slope(point1, point2)
  let b = yIntercept(point1, slope)

  return {m ,b}
}

function perpendicularLine(point1, point2) {
  let lineSlope = slope(point1, point2)
  let perpendicularSlope = -1 / lineSlope
  let midP = midpoint(point1, point2)
  let perpendicularYIntercept = yIntercept(midP, lineSlope)

  return { m: perpendicularSlope,
           b:  perpendicularYIntercept }
}

function yPointOnLine(line, x) {
  return line.m * x + line.b
}

function xPointOnLine(line, y) {
  return (y - line.b) / slope
}

export function distance(point1, point2) {
  let a = point1.x - point2.x
  let b = point1.y - point2.y
  return Math.hypot(a, b)
}
