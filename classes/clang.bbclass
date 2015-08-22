# Add the necessary override
CC_toolchain-clang  = "${TARGET_PREFIX}clang ${HOST_CC_ARCH}${TOOLCHAIN_OPTIONS}"
CXX_toolchain-clang = "${TARGET_PREFIX}clang++ ${HOST_CC_ARCH}${TOOLCHAIN_OPTIONS}"
CPP_toolchain-clang = "${TARGET_PREFIX}clang ${HOST_CC_ARCH}${TOOLCHAIN_OPTIONS} -E"
CCLD_toolchain-clang = "${TARGET_PREFIX}clang ${HOST_CC_ARCH}${TOOLCHAIN_OPTIONS}"
THUMB_TUNE_CCARGS_remove_toolchain-clang = "-mthumb-interwork"
TUNE_CCARGS_append_toolchain-clang = " -D__extern_always_inline=inline -no-integrated-as"

TOOLCHAIN_OPTIONS_append_toolchain-clang_class-nativesdk_x86-64 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux-x86-64.so.2"
TOOLCHAIN_OPTIONS_append_toolchain-clang_class-nativesdk_x86 = " -Wl,-dynamic-linker,${base_libdir}/ld-linux.so.2"

# choose between 'gcc' 'clang' an empty '' can be used as well
TOOLCHAIN ??= "clang"

TOOLCHAIN_class-native = "gcc"

OVERRIDES .= "${@['', ':toolchain-${TOOLCHAIN}']['${TOOLCHAIN}' != '']}"
OVERRIDES[vardepsexclude] += "TOOLCHAIN"

#DEPENDS_append_toolchain-clang_class-target = " clang-cross-${TARGET_ARCH} "
#DEPENDS_remove_toolchain-clang_allarch = "clang-cross-${TARGET_ARCH}"

def clang_dep_prepend(d):
    #
    # Ideally this will check a flag so we will operate properly in
    # the case where host == build == target, for now we don't work in
    # that case though.
    #

    deps = ""
    # INHIBIT_DEFAULT_DEPS doesn't apply to the patch command.  Whether or  not
    # we need that built is the responsibility of the patch function / class, not
    # the application.
    if not d.getVar('INHIBIT_DEFAULT_DEPS', False):
        if not oe.utils.inherits(d, 'allarch'):
            deps += " clang-cross-${TARGET_ARCH} "
    return deps

CLANGDEPENDS = "${@clang_dep_prepend(d)}"

DEPENDS_prepend_toolchain-clang_class-target = "${CLANGDEPENDS} "