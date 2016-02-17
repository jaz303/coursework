typedef float real;
#define GL_REAL GL_FLOAT

struct Context {
    SDL_Window *window;
    SDL_GLContext gl;
    bool quit;
    int width, height;
};

struct Vertex {
    real x, y, z;
    real nx, ny, nz;
    real s0, t0;
};

