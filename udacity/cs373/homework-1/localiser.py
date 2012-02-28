colors = [['red', 'green', 'green', 'red' , 'red'],
          ['red', 'red', 'green', 'red', 'red'],
          ['red', 'red', 'green', 'green', 'red'],
          ['red', 'red', 'red', 'red', 'red']]

measurements = ['green', 'green', 'green' ,'green', 'green']


motions = [[0,0],[0,1],[1,0],[1,0],[0,1]]

sensor_right = 0.7

p_move = 0.8

def show(p):
    for i in range(len(p)):
        print p[i]
        
#DO NOT USE IMPORT
#ENTER CODE BELOW HERE
#ANY CODE ABOVE WILL CAUSE
#HOMEWORK TO BE GRADED
#INCORRECT

height  = len(colors)
width   = len(colors[0])
size    = width * height

# uniform distribution
p = []
for i in range(height):
    row = []
    for j in range(width):
        row.append(1.0 / size)
    p.append(row)

def sense(p, Z):
    q = []
    
    for i in range(height):
        row = []
        for j in range(width):
            if Z == colors[i][j]:
                row.append(p[i][j] * sensor_right)
            else:
                row.append(p[i][j] * (1 - sensor_right))
        q.append(row)
        
    s = 0.0
    for i in range(height):
        for j in range(width):
            s = s + q[i][j]
    
    for i in range(height):
        for j in range(width):
            q[i][j] = q[i][j] / s
    
    return q
    
def move(p, U):
    q = []
    for i in range(height):
        row = []
        for j in range(width):
            s = (1.0 - p_move) * p[i][j]
            s = s + (p_move * p[(i - U[0]) % height][(j - U[1]) % width])
            row.append(s)
        q.append(row)
    return q
 
for i in range(len(measurements)):
    p = move(p, motions[i])
    p = sense(p, measurements[i])
    
show(p)
