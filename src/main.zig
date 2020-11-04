const std = @import("std");

pub extern fn consoleLog(_: c_int) void;
pub extern fn consoleLogF(_: f32) void;
pub extern fn consoleLogS(_: [*]const u8, _: c_uint) void;

const pbr_frag = @embedFile("pbr.frag");
const pbr_vert = @embedFile("pbr.vert");

usingnamespace @import("webgl.zig");

const builtin = @import("builtin");
pub const allocator = @import("std").heap.wasm_allocator;

pub fn panic(message: []const u8, error_return_trace: ?*builtin.StackTrace) noreturn {
    @setCold(true);
    consoleLogS(message.ptr, message.len);
    while (true) {}
}

var frame_id: c_uint = 0;
var prog: c_uint = 0;
var pos: c_uint = 0;
var instance_color: c_uint = 0;
var vao: c_uint = 0;

// I failed to make this function take a slice/array so had to do it like this for now
fn create_and_bind_array_buffer(len: c_uint, data: [*c]const f32) c_uint {
    const buf = glCreateBuffer();
    glBindBuffer(GL_ARRAY_BUFFER, buf);
    glBufferData(GL_ARRAY_BUFFER, len, data, GL_STATIC_DRAW);
    return buf;
}

export fn onInit() void {
    // NOTE: This is without any permutations...
    var fs = glInitShader(pbr_frag, pbr_frag.len, GL_FRAGMENT_SHADER);
    var vs = glInitShader(pbr_vert, pbr_vert.len, GL_VERTEX_SHADER);
    prog = glLinkShaderProgram(vs, fs);

    const positions = [_]f32{0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0};
    pos = create_and_bind_array_buffer(positions.len, &positions);

    // R,G,B
    const ic = [_]f32{1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
    instance_color = create_and_bind_array_buffer(ic.len, &ic);

    vao = glCreateVertexArray();
    glBindVertexArray(vao);

    glEnableVertexAttribArray(0); // Enable channel 0
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3*4, 0); // 3 vertices of 12 bytes

    glEnableVertexAttribArray(1); // Enable channel 1
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 3*4, 0); // 3 vertices of 12 bytes
    glVertexAttribDivisor(1, 1); // One vertex per instance

    glBindVertexArray(0);
}

export fn onAnimationFrame(now_time: c_int) void {
    glClearColor(@sin(@intToFloat(f32, frame_id)*0.01) * 0.5 + 0.5, 0.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    frame_id = frame_id + 1;

    glUseProgram(prog);
    glBindVertexArray(vao);
    glDrawArraysInstanced(GL_TRIANGLES, 0, 3, 3); // 3 instances
    
    glBindVertexArray(0);
    glUseProgram(0);
}

export fn onDestroy() void {
}
