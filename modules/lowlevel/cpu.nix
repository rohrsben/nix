{
  den.aspects.cpu = {
    nixos = {
      hardware = {
        enableRedistributableFirmware = true;
        cpu.intel.updateMicrocode = true;
      };
    };
  };
}
