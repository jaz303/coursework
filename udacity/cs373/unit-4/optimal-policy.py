# ----------
# User Instructions:
# 
# Create a function optimum_path() which returns
# a grid of values. Value is defined as the minimum
# number of moves required to get from a cell to the
# goal. 
#
# If it is impossible to reach the goal from a cell
# you should assign that cell a value of 99.

# ----------

grid = [[0, 1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0]]

init = [0, 0]
goal = [len(grid)-1, len(grid[0])-1]

delta = [[-1, 0 ], # go up
         [ 0, -1], # go left
         [ 1, 0 ], # go down
         [ 0, 1 ]] # go right

delta_name = ['^', '<', 'v', '>']

cost_step = 1 # the cost associated with moving from a cell to an adjacent one.

# ----------------------------------------
# insert code below
# ----------------------------------------

def optimum_path_r(policy, out, x, y):
    explore = []
    current_value = out[x][y]
    for i in range(len(delta)):
        x2 = x + delta[i][0]
        y2 = y + delta[i][1]
        if x2 >= 0 and x2 < len(grid) and y2 >=0 and y2 < len(grid[0]):
            if grid[x2][y2] == 0 and current_value < out[x2][y2]:
                explore.append([x2, y2])
                policy[x2][y2] = delta_name[(i+2)%4]
                out[x2][y2] = out[x][y] + 1
    for x in explore:
        optimum_path_r(policy, out, x[0], x[1])

def optimum_path():
    policy = [[' ' for row in range(len(grid[0]))] for col in range(len(grid))]
    policy[goal[0]][goal[1]] = '*'
    value = [[99 for row in range(len(grid[0]))] for col in range(len(grid))]
    value[goal[0]][goal[1]] = 0
    optimum_path_r(policy, value, goal[0], goal[1])
    return policy #make sure your function returns a grid of values as demonstrated in the previous video.

out = optimum_path()
for i in out:
    print i
