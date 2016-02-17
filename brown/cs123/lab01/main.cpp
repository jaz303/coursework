#include "prelude.inc.cpp"
#include "types.inc.cpp"
#include "init.inc.cpp"
#include "gl.inc.cpp"
#include "shapes.inc.cpp"

const int SCREEN_WIDTH = 600;
const int SCREEN_HEIGHT = 600;

const char *VERTEX_SHADER =
    "#version 400\n"
    "layout(location = 0) in vec3 vertex_position;\n"
    "void main() {\n"
    "  gl_Position = vec4(vertex_position, 1.0);\n"
    "}\n";

const char *FRAGMENT_SHADER =
    "#version 400\n"
    "out vec4 frag_colour;\n"
    "void main() {\n"
    "  frag_colour = vec4(1.0, 1.0, 1.0, 1.0);\n"
    "}\n";

Context gContext;
Shape *gShape;
GLuint gProgram;

void handleKeys(unsigned char key, int x, int y) {
    if (key == 'q') {
        gContext.quit = true;
    }
}

void update() {
    
}

void render() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    gShape->draw();
}

int main(int argc, char* args[])
{
    if (!init(SCREEN_WIDTH, SCREEN_HEIGHT, "Lab 01", &gContext)) {
        fprintf(stderr, "Failed to initialize\n");
        return 1;
    }

    gProgram = gl_compileShaderProgram(VERTEX_SHADER, FRAGMENT_SHADER);
    // gShape = shapes_makeTriangleStrip();
    gShape = shapes_makeCircle(100, 0.4);

    glUseProgram(gProgram);

    SDL_Event e;
    SDL_StartTextInput();

    while (!gContext.quit) {
        while(SDL_PollEvent(&e) != 0) {
            if (e.type == SDL_QUIT) {
                gContext.quit = true;
            } else if(e.type == SDL_TEXTINPUT) {
                int x = 0, y = 0;
                SDL_GetMouseState(&x, &y);
                handleKeys(e.text.text[0], x, y);
            }
        }
        render();
        SDL_GL_SwapWindow(gContext.window);
    }
    
    SDL_StopTextInput();
    shutdown(&gContext);

    return 0;
}