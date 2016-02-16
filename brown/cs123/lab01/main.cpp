#include <SDL2/SDL.h>
#include <SDL2/SDL_opengl.h>
#include <stdio.h>

const int SCREEN_WIDTH = 800;
const int SCREEN_HEIGHT = 600;

struct Vertex {
    float x, y, z;
    float nx, ny, nz;
    float s0, t0;
};

class MyShape {
public:
	MyShape() {
		
		Vertex pvertex[3];
		//VERTEX 0
		pvertex[0].x = 0.0;
		pvertex[0].y = 0.0;
		pvertex[0].z = 0.0;
		pvertex[0].nx = 0.0;
		pvertex[0].ny = 0.0;
		pvertex[0].nz = 1.0;
		pvertex[0].s0 = 0.0;
		pvertex[0].t0 = 0.0;
		//VERTEX 1
		pvertex[1].x = 1.0;
		pvertex[1].y = 0.0;
		pvertex[1].z = 0.0;
		pvertex[1].nx = 0.0;
		pvertex[1].ny = 0.0;
		pvertex[1].nz = 1.0;
		pvertex[1].s0 = 1.0;
		pvertex[1].t0 = 0.0;
		//VERTEX 2
		pvertex[2].x = 0.0;
		pvertex[2].y = 1.0;
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
		glBindBuffer(GL_ARRAY_BUFFER, 0);

		glGenBuffers(1, &vaoID_);
		
		glBindBuffer(GL_ARRAY_BUFFER, vboID_);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vaoID_);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(ushort)*3, pindices, GL_STATIC_DRAW);
		glEnableClientState(GL_VERTEX_ARRAY);
		glVertexPointer(3, GL_FLOAT, sizeof(Vertex), (void*)0);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	}

	~MyShape() {
		glDeleteBuffers(1, &vboID_);
		//glDeleteVertexArrays(1, &vaoID_);
	}

	void draw() {
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vaoID_);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
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
        //Use OpenGL 2.1
        SDL_GL_SetAttribute( SDL_GL_CONTEXT_MAJOR_VERSION, 2 );
        SDL_GL_SetAttribute( SDL_GL_CONTEXT_MINOR_VERSION, 1 );

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

                //Initialize OpenGL
                if( !initGL() )
                {
                    printf( "Unable to initialize OpenGL!\n" );
                    success = false;
                }
            }
        }
    }

    return success;
}

bool initGL()
{
    bool success = true;
    GLenum error = GL_NO_ERROR;

    //Initialize Projection Matrix
    glMatrixMode( GL_PROJECTION );
    glLoadIdentity();
    
    //Check for error
    error = glGetError();
    if( error != GL_NO_ERROR )
    {
        success = false;
    }

    //Initialize Modelview Matrix
    glMatrixMode( GL_MODELVIEW );
    glLoadIdentity();

    //Check for error
    error = glGetError();
    if( error != GL_NO_ERROR )
    {
        success = false;
    }
    
    //Initialize clear color
    glClearColor( 0.f, 0.f, 0.f, 1.f );
    
    //Check for error
    error = glGetError();
    if( error != GL_NO_ERROR )
    {
        success = false;
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
    //Clear color buffer
    glClear( GL_COLOR_BUFFER_BIT );
    
    //Render quad
    if( gRenderQuad )
    {
        glRotatef(0.4f,0.0f,1.0f,0.0f);    // Rotate The cube around the Y axis
        glRotatef(0.2f,1.0f,1.0f,1.0f);
        glColor3f(0.0f,1.0f,0.0f); 

        glBegin( GL_QUADS );
            glVertex2f( -0.5f, -0.5f );
            glVertex2f( 0.5f, -0.5f );
            glVertex2f( 0.5f, 0.5f );
            glVertex2f( -0.5f, 0.5f );
        glEnd();
    }
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
    //Start up SDL and create window
    if( !init() )
    {
        printf( "Failed to initialize!\n" );
    }
    else
    {

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
    }

    //Free resources and close SDL
    close();

    return 0;
}