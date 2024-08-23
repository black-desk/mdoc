cmake_minimum_required(VERSION 3.11.4) # for RHEL 8

# Let's place extra cmake scripts in /cmake directory
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

project(
  mdoc
  VERSION 0.1.4
  DESCRIPTION "A script wrapper for pandoc to convote markdown to pdf."
  HOMEPAGE_URL "https://github.com/black-desk/mdoc"
  LANGUAGES C)

# Use this command to update GitSemver.cmake from GitHub release page: wget -O
# cmake/GitSemver.cmake
# https://github.com/black-desk/GitSemver.cmake/releases/latest/download/GitSemver.cmake
include(GitSemver)
gitsemver(PROJECT_VERSION)

include(GNUInstallDirs)

set(MDOC_FILTERS include-files.lua include-code-files.lua diagram.lua)
set(MDOC_TEMPLATES default.typst)

configure_file(./src/mdoc mdoc @ONLY)
install(PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/mdoc"
        DESTINATION "${CMAKE_INSTALL_FULL_BINDIR}")

set(MDOC_FILTER_FILES)
foreach(filter ${MDOC_FILTERS})
  set(MDOC_FILTER_FILES ${MDOC_FILTER_FILES}
                        "${CMAKE_CURRENT_SOURCE_DIR}/misc/filters/${filter}")
endforeach()
install(FILES ${MDOC_FILTER_FILES}
        DESTINATION "${CMAKE_INSTALL_FULL_DATADIR}/mdoc/filters")

set(MODC_TEMPLATE_FILES)
foreach(template ${MDOC_TEMPLATES})
  set(MODC_TEMPLATE_FILES
      ${MODC_TEMPLATE_FILES}
      "${CMAKE_CURRENT_SOURCE_DIR}/misc/templates/${template}")
endforeach()

install(FILES ${MODC_TEMPLATE_FILES}
        DESTINATION "${CMAKE_INSTALL_FULL_DATADIR}/mdoc/templates")
