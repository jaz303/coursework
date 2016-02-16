#include <OpenGL/gl3.h>
#include <SDL2/SDL.h>
#include <stdio.h>

const int SCREEN_WIDTH = 800;
const int SCREEN_HEIGHT = 600;

typedef float real;
#define GL_REAL GL_FLOAT

struct Vertex {
    real x, y, z;
    real nx, ny, nz;
    real s0, t0;
};

class MyShape {
public:
	MyShape() {
		
		Vertex pvertex[3];
		//VERTEX 0
		pvertex[0].x = 0.0;
		pvertex[0].y = 0.75;
		pvertex[0].z = 0.0;
		pvertex[0].nx = 0.0;
		pvertex[0].ny = 0.0;
		pvertex[0].nz = 1.0;
		pvertex[0].s0 = 0.0;
		pvertex[0].t0 = 0.0;
		//VERTEX 1
		pvertex[1].x = -0.75;
		pvertex[1].y = -0.75;
		pvertex[1].z = 0.0;
		pvertex[1].nx = 0.0;
		pvertex[1].ny = 0.0;
		pvertex[1].nz = 1.0;
		pvertex[1].s0 = 1.0;
		pvertex[1].t0 = 0.0;
		//VERTEX 2
		pvertex[2].x = 0.75;
		pvertex[2].y = -0.75;
		pvertex[2].z = 0.0;
		pvertex[2].nx = 0.0;
		pvertex[2].ny = 0.0;
		pvertex[2].nz = 1.0;
		pvertex[2].s0 = 0.0;
		pvertex[2].t0 = 1.0;

		ushort pindices[3];
		pindices[0] = 0;
		pindices[1] = 1;
		pindices[2] = 2;

        glGenBuffers(1, &vboID_);
		glBindBuffer(GL_ARRAY_BUFFER, vboID_);
		glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*3, &pvertex[0].x, GL_STATIC_DRAW);

        glGenVertexArrays(1, &vaoID_);
        glBindVertexArray(vaoID_);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 3, GL_REAL, GL_FALSE, sizeof(Vertex), NULL);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);
	}

	~MyShape() {
		glDeleteBuffers(1, &vboID_);
		glDeleteVertexArrays(1, &vaoID_);
	}

	void draw() {
        glBindVertexArray(vaoID_);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        glBindVertexArray(0);
	}

private:
	GLuint vboID_;
	GLuint vaoID_;
};

bool init();
bool initGL();
void handleKeys( unsigned char key, int x, int y );
void update();
void render();
void close();

bool quit = false;
SDL_Window* gWindow = NULL;
SDL_GLContext gContext;
bool gRenderQuad = true;

MyShape *gShape;
GLuint gProgram;

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

GLuint compileShader(const char *source, GLuint type) {
    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        return 0;
    }
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);
    GLint success = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE) {
        printf("shader compile error\n");
        return 0;
    }
    return shader;
}

GLuint compileShaderProgram(const char *vertexShader, const char *fragmentShader) {
    GLuint vs = compileShader(vertexShader, GL_VERTEX_SHADER);
    GLuint fs = compileShader(fragmentShader, GL_FRAGMENT_SHADER);
    if (vs == 0 || fs == 0) {
        // TODO: destroy
        return 0;
    }
    GLuint prog = glCreateProgram();
    if (prog == 0) {
        // TODO: destroy
        return prog;
    }
    glAttachShader(prog, vs);
    glAttachShader(prog, fs);
    glLinkProgram(prog);
    GLint success = 0;
    glGetProgramiv(prog, GL_LINK_STATUS, (int*)&success);
    if (success == GL_FALSE) {
        printf("shader link error\n");
        // TODO: destroy
        return 0;
    }
    return prog;
}


bool init()
{
    //Initialization flag
    bool success = true;

    //Initialize SDL
    if( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    {
        printf( "SDL could not initialize! SDL Error: %s\n", SDL_GetError() );
        success = false;
    }
    else
    {
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

        //Create window
        gWindow = SDL_CreateWindow( "SDL Tutorial", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN );
        if( gWindow == NULL )
        {
            printf( "Window could not be created! SDL Error: %s\n", SDL_GetError() );
            success = false;
        }
        else
        {
            //Create context
            gContext = SDL_GL_CreateContext( gWindow );
            if( gContext == NULL )
            {
                printf( "OpenGL context could not be created! SDL Error: %s\n", SDL_GetError() );
                success = false;
            }
            else
            {
                //Use Vsync
                if( SDL_GL_SetSwapInterval( 1 ) < 0 )
                {
                    printf( "Warning: Unable to set VSync! SDL Error: %s\n", SDL_GetError() );
                }
            }
        }
    }

    return success;
}

void handleKeys(unsigned char key, int x, int y)
{
    if (key == 'q') {
        quit = true;
    }
}

void update()
{
    //No per frame update needed
}

void render()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUseProgram(gProgram);
    gShape->draw();
}

void close()
{
    //Destroy window    
    SDL_DestroyWindow( gWindow );
    gWindow = NULL;

    //Quit SDL subsystems
    SDL_Quit();
}

int main( int argc, char* args[] )
{
    if (!init()) {
        printf( "Failed to initialize!\n" );
    }

    gProgram = compileShaderProgram(VERTEX_SHADER, FRAGMENT_SHADER);
    gShape = new MyShape();

    glEnable(GL_CULL_FACE);

    //Event handler
    SDL_Event e;
    
    //Enable text input
    SDL_StartTextInput();

    //While application is running
    while( !quit )
    {
        //Handle events on queue
        while( SDL_PollEvent( &e ) != 0 )
        {
            //User requests quit
            if( e.type == SDL_QUIT )
            {
                quit = true;
            }
            //Handle keypress with current mouse position
            else if( e.type == SDL_TEXTINPUT )
            {
                int x = 0, y = 0;
                SDL_GetMouseState( &x, &y );
                handleKeys( e.text.text[ 0 ], x, y );
            }
        }

        //Render quad
        render();
        
        //Update screen
        SDL_GL_SwapWindow( gWindow );
    }
    
    //Disable text input
    SDL_StopTextInput();

    //Free resources and close SDL
    close();

    return 0;
}