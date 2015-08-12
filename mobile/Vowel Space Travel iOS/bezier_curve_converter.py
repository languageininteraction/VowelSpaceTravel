class Point():

	def __init__(self,x,y):

		self.x = x
		self.y = y

class Curve():

	def __init__(self,endpoint,controlpoint1,controlpoint2):

		self.endpoint = endpoint
		self.controlpoint1 = controlpoint1
		self.controlpoint2 = controlpoint2

class Path():

	def __init__(self,startpoint,curves):

		self.startpoint = startpoint
		self.curves = curves

	def normalize(self):

		#Find the smallest x and y
		smallest_x = self.startpoint.x
		smallest_y = self.startpoint.y

		for curve in self.curves:
			for point in [curve.endpoint,curve.controlpoint1,curve.controlpoint2]:

				if point.x < smallest_x:
					smallest_x = point.x

				if point.y < smallest_y:
					smallest_y = point.y

		#Move the whole thing to the upper left corner
		self.startpoint.x -= smallest_x
		self.startpoint.y -= smallest_y

		for curve in self.curves:
			for point in [curve.endpoint,curve.controlpoint1,curve.controlpoint2]:
				point.x -= smallest_x
				point.y -= smallest_y

def string_to_point(string,last_active_point=None):

	x,y = [float(i) for i in string.split(',')]

	if last_active_point != None:
		x += last_active_point.x
		y += last_active_point.y

	return Point(x,y)

def svg_path_string_to_path(path_string):

	CURVES_INDEX_OFFSET = 3
	NUMBER_OF_ITEMS_PER_CURVE = 3

	items = path_string.replace('z','').split()
	startpoint = string_to_point(items[1])
	last_active_point = startpoint

	curves = []
	reached_end = False
	c = 0

	while True:

		starting_index = CURVES_INDEX_OFFSET + c*NUMBER_OF_ITEMS_PER_CURVE

		try:
			controlpoint1 = string_to_point(items[starting_index],last_active_point)
			controlpoint2 = string_to_point(items[starting_index+1],last_active_point)
			endpoint = string_to_point(items[starting_index+2],last_active_point)
		except IndexError:
			print('Broke at',starting_index)
			break

		curves.append(Curve(endpoint,controlpoint1,controlpoint2))
		print('Added curve')
		last_active_point = endpoint
		c+= 1

	return Path(startpoint,curves)

def path_to_uibezierpath(path):

	print('myBezier.moveToPoint(CGPoint(x: '+str(path.startpoint.x)+', y:'+str(path.startpoint.y)+'))')

	for curve in path.curves:

		print('myBezier.addCurveToPoint(CGPoint(x: '+str(curve.endpoint.x)+', y: '+str(curve.endpoint.y)+'),')
		print('   controlPoint1: CGPoint(x: '+str(curve.controlpoint1.x)+', y:'+str(curve.controlpoint1.y)+'),')
		print('   controlPoint2: CGPoint(x: '+str(curve.controlpoint2.x)+', y:'+str(curve.controlpoint2.y)+'))')

if __name__ == '__main__':

	PATH_STRING = 'm 423.73552,564.51162 c -0.0312,0.34375 -0.0777,0.50889 -0.17142,0.94639 0.71875,0.21875 1.83877,0.51516 1.93566,1.44416 -7.48928,-0.65181 -12.05796,-3.03515 -12.01377,-3.34451 0.0442,-0.35355 1.66199,-0.0496 2.44324,0.10669 0.125,-0.40625 0.31158,-0.7071 0.31158,-0.7071 -0.75,-0.15625 -3.35875,-0.7513 -3.62392,0.22097 -0.15625,0.5 -0.26072,0.5736 0.17678,1.10485 3.49134,2.43068 10.87176,3.40295 12.63953,3.49134 1.94454,-0.22097 1.11022,-1.53515 0.23522,-2.3164 -0.61872,-0.44194 -1.3079,-0.75889 -1.9329,-0.94639 z'
	path = svg_path_string_to_path(PATH_STRING)
	path.normalize()
	path_to_uibezierpath(path)