# Ensure Dlib paths are included
include_directories(${DLIB_INCLUDE_DIR})
link_directories(${DLIB_LIBRARY})

# Add the executable
add_executable(xml_generator main.cc)

# Link against Dlib manually if needed
target_link_libraries(xml_generator ${DLIB_LIBRARY})
