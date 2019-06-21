attribute vec3 a_Position;
attribute vec2 a_UV;
attribute vec3 a_Normal;

uniform mat4 matrix_model;
uniform mat4 matrix_viewProjection;

varying vec2 v_UV;
varying vec3 v_Position;
varying vec3 v_Normal;

void main(void)
{
    v_UV = a_UV;
    v_Position = a_Position;
    v_Normal = a_Normal;
    gl_Position = matrix_viewProjection * matrix_model * vec4(a_Position, 1.0);
}
