export XDG_RUNTIME_DIR=/tmp

# TODO This should be started as a systemd service
echo "Starting weston in the guest"
nohup /usr/bin/openvt -c 7 -w -v -s -- weston --backend=drm-backend.so --use-pixman --log weston.log &
sleep 3

export WAYLAND_DISPLAY=wayland-0
export PIGLIT_DEQP_EXTRA_ARGS="--deqp-watchdog=enable --deqp-crashhandler=enable"
export PIGLIT_DEQP_GLES2_BIN=/usr/local/VK-GL-CTS/build/modules/gles2/deqp-gles2
export PIGLIT_DEQP_GLES3_BIN=/usr/local/VK-GL-CTS/build/modules/gles3/deqp-gles3

cd /usr/local/VK-GL-CTS/build/external/openglcts/modules/

time strace -ff ./glcts --deqp-case=dEQP-GLES2*limits* --deqp-watchdog=enable --deqp-crashhandler=enable

time sh -c "./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.vertex_attribs && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.varying_vectors && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.vertex_uniform_vectors && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.fragment_uniform_vectors && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.texture_image_units && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.vertex_texture_image_units && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.combined_texture_image_units && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.texture_2d_size && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.texture_cube_size && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.capability.limits.renderbuffer_size && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.subpixel_bits && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_texture_size && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_cube_map_texture_size && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.aliased_point_size_range && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.aliased_line_width_range && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.num_compressed_texture_formats && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.num_shader_binary_formats && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.shader_compiler && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_vertex_attribs && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_vertex_uniform_vectors && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_varying_vectors && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_combined_texture_image_units && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_vertex_texture_image_units && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_texture_image_units && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_fragment_uniform_vectors && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.implementation_limits.max_renderbuffer_size && \
./glcts --deqp-watchdog=enable --deqp-crashhandler=enable --deqp-case=dEQP-GLES2.functional.rasterization.limits.points"

cd /usr/local/piglit
mkdir -p /virglrenderer/results

time ./piglit run -p wayland -t limits deqp_gles2 /virglrenderer/results

#./piglit run -p wayland deqp_gles2 deqp_gles3 /virglrenderer/results
