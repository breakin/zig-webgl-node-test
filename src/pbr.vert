#version 300 es
precision highp float;

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 instance_color;
out vec3 color;

uniform mat4 u_project_to_object;

void main() {
    color = instance_color;
    vec3 op = position;
    op.x *= 0.3;
    op.x += float(gl_InstanceID)*0.33;
    gl_Position = (/*u_project_to_object */ vec4(op, 1.0));
}
