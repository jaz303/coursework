# ----------
# User Instructions:
# 
# Implement the function optimum_policy2D() below.
#
# You are given a car in a grid with initial state
# init = [x-position, y-position, orientation]
# where x/y-position is its position in a given
# grid and orientation is 0-3 corresponding to 'up',
# 'left', 'down' or 'right'.
#
# Your task is to compute and return the car's optimal
# path to the position specified in `goal'; where
# the costs for each motion are as defined in `cost'.

# EXAMPLE INPUT:

# grid format:
#     0 = navigable space
#     1 = occupied space 
grid = [[1, 1, 1, 0, 0, 0],
        [1, 1, 1, 0, 1, 0],
        [0, 0, 0, 0, 0, 0],
        [1, 1, 1, 0, 1, 1],
        [1, 1, 1, 0, 1, 1]]
goal = [2, 0] # final position
init = [4, 3, 0] # first 2 elements are coordinates, third is direction
cost = [2, 1, 2] # the cost field has 3 values: right turn, no turn, left turn

# EXAMPLE OUTPUT:
# calling optimum_policy2D() should return the array
# 
# [[' ', ' ', ' ', 'R', '#', 'R'],
#  [' ', ' ', ' ', '#', ' ', '#'],
#  ['*', '#', '#', '#', '#', 'R'],
#  [' ', ' ', ' ', '#', ' ', ' '],
#  [' ', ' ', ' ', '#', ' ', ' ']]
#
# ----------


# there are four motion directions: up/left/down/right
# increasing the index in this array corresponds to
# a left turn. Decreasing is is a right turn.

forward = [[-1,  0], # go up
           [ 0, -1], # go left
           [ 1,  0], # go down
           [ 0,  1]] # do right
forward_name = ['up', 'left', 'down', 'right']

# the cost field has 3 values: right turn, no turn, left turn
action = [-1, 0, 1]
action_name = ['R', '#', 'L']


# ----------------------------------------
# modify code below
# ----------------------------------------

def optimum_policy2D():
    value = [[[999 for row in range(len(grid[0]))] for col in range(len(grid))],
             [[999 for row in range(len(grid[0]))] for col in range(len(grid))],
             [[999 for row in range(len(grid[0]))] for col in range(len(grid))],
             [[999 for row in range(len(grid[0]))] for col in range(len(grid))]]
             
    policy = [[[' ' for row in range(len(grid[0]))] for col in range(len(grid))],
              [[' ' for row in range(len(grid[0]))] for col in range(len(grid))],
              [[' ' for row in range(len(grid[0]))] for col in range(len(grid))],
              [[' ' for row in range(len(grid[0]))] for col in range(len(grid))]]

    policy2D = [[' ' for row in range(len(grid[0]))] for col in range(len(grid))]
    
    changed = True
    while changed:
        changed = False
        
        for x in range(len(grid)):
            for y in range(len(grid[0])):
                for d in range(len(forward)):
                    
                    if x == goal[0] and y == goal[1]:
                        if value[d][x][y] != 0:
                            value[d][x][y] = 0
                            policy[d][x][y] = '*'
                            changed = True
                    
                    elif grid[x][y] == 0:
                        for a in range(len(action)):
                            d2 = (d + action[a]) % 4
                            x2 = x + forward[d2][0]
                            y2 = y + forward[d2][1]
                            
                            if x2 >= 0 and x2 < len(grid) and y2 >= 0 and y2 < len(grid[0]) and grid[x2][y2] == 0:
                                v2 = value[d2][x2][y2] + cost[a]
                            
                                if v2 < value[d][x][y]:
                                    changed = True
                                    value[d][x][y] = v2
                                    policy[d][x][y] = action_name[a]
                    
    x = init[0]                
    y = init[1]
    d = init[2]
    
    policy2D[x][y] = policy[d][x][y]
    while policy[d][x][y] != '*':
        if policy[d][x][y] == '#':
            d2 = d
        elif policy[d][x][y] == 'R':
            d2 = (d - 1) % 4
        elif policy[d][x][y] == 'L':
            d2 = (d + 1) % 4
        x = x + forward[d2][0]
        y = y + forward[d2][1]
        d = d2
        policy2D[x][y] = policy[d][x][y]
    
    # while value[d][x][y] > 0:
    #     best_a = -1
    #     best_value = 1000
    #     for a in range(len(action)):
    #         new_d = (d + action[a]) % 4
    #         new_x = x + forward[new_d][0]
    #         new_y = y + forward[new_d][1]
    #         if value[new_d][new_x][new_y] < best_value:
    #             best_value = value[new_d][new_x][new_y]
    #             best_a = a
    #     policy2D[x][y] = action_name[best_a]
    #     d = (d + action[best_a]) % 4
    #     x = x + forward[d][0]
    #     y = y + forward[d][1]
            
    policy2D[x][y] = '*'
                
    return policy2D # Make sure your function returns the expected grid.

p = optimum_policy2D()
for i in p:
    print i

