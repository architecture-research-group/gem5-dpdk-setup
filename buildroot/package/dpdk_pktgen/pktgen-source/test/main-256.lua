package.path = package.path ..";?.lua;test/?.lua;app/?.lua;"

require "Pktgen"

-- A list of the test script for Pktgen and Lua.
-- Each command somewhat mirrors the pktgen command line versions.
-- A couple of the arguments have be changed to be more like the others.
--

-- 'set' commands for a number of per port values
pktgen.set("0", "rate", 34);
pktgen.set("0", "size", 256);
pktgen.set("0", "burst", 128);

pktgen.set_mac("0","src", "0090:0000:0001");
pktgen.set_mac("0", "dst","0090:0000:0002");
pktgen.start("0");
--pktgen.stop("all");

printf("Lua Version      : %s\n", pktgen.info.Lua_Version);
printf("Pktgen Version   : %s\n", pktgen.info.Pktgen_Version);
printf("Pktgen Copyright : %s\n", pktgen.info.Pktgen_Copyright);

prints("pktgen.info", pktgen.info);

printf("Port Count %d\n", pktgen.portCount());
printf("Total port Count %d\n", pktgen.totalPorts());

printf("\nDone\n");
