-- Version number
local Version = "3.2.1a"
local AppName = "SOLPS_ITER"
local AppPath = "/global/common/software/m3739/perlmutter/SOLPS-ITER/"
local conda_env_path = "/global/common/software/m3739/perlmutter/conda_envs/solps_env"
-- Sets module help message
help(
[[
    This module provides the SOLPS-ITER code. Can only be loaded from a 
    tcsh shell.
    Important note:
    SOLPS-ITER falls under the IMAS user agreement. If your organization
    has signed this agreement and would like access pleace contact
    fus@fusion.gat.com. 
]])


whatis("Name        : " .. AppName)
whatis("Version     : " .. Version)
if(mode() == "load")
then
    if(not (myShellName() == "tcsh") )
    then
        LmodMessage ("You have to enter a tcsh shell before loading this module. You can start a tcsh shell by typing `tcsh` and hitting enter.")
        LmodError("SOLPS-ITER can only be loaded from tcsh.")
    end
end
setenv("CRAY_ADD_RPATH", "yes")
append_path("LD_LIBRARY_PATH", os.getenv("CRAY_LD_LIBRARY_PATH"))

depends_on("cray-hdf5")
depends_on("cray-netcdf")
conflict("conda")

-- setup compiler variables
local fc = capture("which ftn"):gsub("%s+$", "")
local cc = capture("which cc"):gsub("%s+$", "")
local cxx = capture("which CC"):gsub("%s+$", "")

setenv("FC", fc)
setenv("F90", fc)
setenv("F77", fc)
setenv("CC", cc)
setenv("CXX", cxx)

setenv("NCDIR", os.getenv("NETCDF_DIR"))
setenv("H5DIR", os.getenv("HDF5_DIR"))

setenv("HOST_NAME", "NERSC")
setenv("COMPILER", "cray")
local conda_root = "/global/common/software/nersc/pe/conda/26.1.0/Miniforge3-25.11.0-1/"
setenv("CONDA_ROOT", conda_root)

-- setenv("MSCL_ROOT", os.getenv("MSCL_DIR"))
-- setenv("GR_ROOT", os.getenv("GR_DIR"))

setenv("SYSNAME", "x86_64_rhel8")
setenv("HOSTNAME", "NERSC")
setenv("TOOLCHAIN", "cray")

setenv(string.upper(AppName) .. "_DIR", AppPath)
setenv("SOLPSTOP", AppPath)
setenv("SOLPSWORK", pathJoin("/global/cfs/cdirs/m3739/solps-results/", os.getenv("USER")))

-- Hack conda source replacement here
setenv("CONDA_PREFIX", conda_env_path)
setenv("CONDA_DEFAULT_ENV", "solps_env")
append_path("PATH", conda_env_path.."/bin")

setenv("NCARG_ROOT", os.getenv("CONDA_PREFIX"))
prepend_path("PKG_CONFIG_PATH", pathJoin(conda_env_path, "lib", "pkgconfig"))

setenv("SOLPS_LIB", AppPath .. "lib")
source_sh("tcsh", pathJoin(AppPath, "SETUP/setup.csh.NERSC.cray"))
