// Panasonic CF-QV1 fix: define missing DPP1-DPP5 methods referenced by
// the _STA methods of the MCHP1930 (PAC1934) power-monitor devices.
// Installed via the kernel initrd ACPI table override mechanism.
DefinitionBlock ("SSDT-DPP-FIX.aml", "SSDT", 2, "MATBIO", "DppFix  ", 0x00000000)
{
    Method (DPP1, 0, NotSerialized)
    {
        Return (One)
    }

    Method (DPP2, 0, NotSerialized)
    {
        Return (One)
    }

    Method (DPP3, 0, NotSerialized)
    {
        Return (One)
    }

    Method (DPP4, 0, NotSerialized)
    {
        Return (One)
    }

    Method (DPP5, 0, NotSerialized)
    {
        Return (One)
    }
}
