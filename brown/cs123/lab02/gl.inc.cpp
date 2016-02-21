GLuint gl_compileShader(const char *source, GLuint type) {
    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        return 0;
    }
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);
    GLint success = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE) {
        fprintf(stderr, "shader compile error\n");
        return 0;
    }
    return shader;
}

GLuint gl_compileShaderProgram(const char *vertexShader, const char *fragmentShader) {
    GLuint vs = gl_compileShader(vertexShader, GL_VERTEX_SHADER);
    GLuint fs = gl_compileShader(fragmentShader, GL_FRAGMENT_SHADER);
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
        fprintf(stderr, "shader link error\n");
        // TODO: destroy
        return 0;
    }
    return prog;
}