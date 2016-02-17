class Shape {
public:
    Shape(GLenum drawMode, Vertex *vertices, GLsizei vertexCount) {
        drawMode_ = drawMode;
        vertexCount_ = vertexCount;

        glGenBuffers(1, &vboID_);
        glBindBuffer(GL_ARRAY_BUFFER, vboID_);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*vertexCount, &vertices[0].x, GL_STATIC_DRAW);

        glGenVertexArrays(1, &vaoID_);
        glBindVertexArray(vaoID_);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 3, GL_REAL, GL_FALSE, sizeof(Vertex), NULL);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);
    }

    ~Shape() {
        glDeleteBuffers(1, &vboID_);
        glDeleteVertexArrays(1, &vaoID_);
    }

    void draw() {
        glBindVertexArray(vaoID_);
        glDrawArrays(drawMode_, 0, vertexCount_);
        glBindVertexArray(0);
    }

private:
    GLenum drawMode_;
    GLsizei vertexCount_;
    GLuint vboID_;
    GLuint vaoID_;
};

Shape* shapes_makeTriangle() {

    Vertex v[3];
    
    v[0].x = 0.0;
    v[0].y = 0.75;
    v[0].z = 0.0;
    // v[0].nx = 0.0;
    // v[0].ny = 0.0;
    // v[0].nz = 1.0;
    // v[0].s0 = 0.0;
    // v[0].t0 = 0.0;
    
    v[1].x = -0.75;
    v[1].y = -0.75;
    v[1].z = 0.0;
    // v[1].nx = 0.0;
    // v[1].ny = 0.0;
    // v[1].nz = 1.0;
    // v[1].s0 = 1.0;
    // v[1].t0 = 0.0;
    
    v[2].x = 0.75;
    v[2].y = -0.75;
    v[2].z = 0.0;
    // v[2].nx = 0.0;
    // v[2].ny = 0.0;
    // v[2].nz = 1.0;
    // v[2].s0 = 0.0;
    // v[2].t0 = 1.0;

    return new Shape(GL_TRIANGLES, v, 3);

}

Shape* shapes_makeTriangleStrip() {

    Vertex v[6];

    v[0].x = -0.5; v[0].y =  0.5; v[0].z = 0.0;
    v[1].x = -0.5; v[1].y = -0.5; v[1].z = 0.0;
    v[2].x =  0.0; v[2].y =  0.5; v[2].z = 0.0;
    v[3].x =  0.0; v[3].y = -0.5; v[3].z = 0.0;
    v[4].x =  0.5; v[4].y =  0.5; v[4].z = 0.0;
    v[5].x =  0.5; v[5].y = -0.5; v[5].z = 0.0;

    return new Shape(GL_TRIANGLE_STRIP, v, 6);

}

Shape* shapes_makeCircle(int edges, double radius) {

    Vertex v[edges + 2];

    v[0].x = v[0].y = v[0].z = 0.0;
    
    double step = (M_PI * 2) / edges;
    for (int i = 1; i <= edges; ++i) {
        double angle = (i - 1) * step;
        v[i].x = cos(angle) * radius;
        v[i].y = sin(angle) * radius;
        v[i].z = 0.0;
    }

    v[edges+1] = v[1];

    return new Shape(GL_TRIANGLE_FAN, v, edges + 2);

}