struct Context {
    SDL_Window *window;
    SDL_GLContext gl;
    bool quit;
    int width, height;
};

struct Vertex {
	glm::vec3 p;
    float nx, ny, nz;
    float s0, t0;
};
