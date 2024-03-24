library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
    Port (
        clk : in STD_LOGIC;            -- Clock input
        regWrite : in STD_LOGIC;       -- Write control signal
        writeRegNum : in unsigned(4 downto 0);  -- Write register address
        readRegNum1 : in unsigned(4 downto 0);   -- Read register address 1
        readRegNum2 : in unsigned(4 downto 0);   -- Read register address 2
        dataIn : in std_logic_vector(31 downto 0);    -- Data input for write
        dataOut1 : out std_logic_vector(31 downto 0); -- Data output for read 1
        dataOut2 : out std_logic_vector(31 downto 0)  -- Data output for read 2
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    type RegisterArray is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal registers : RegisterArray;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Write phase
            if regWrite = '1' then
                registers(to_integer(writeRegNum)) <= dataIn;
            end if;
        elsif falling_edge(clk) then
            -- Read phase
            dataOut1 <= registers(to_integer(readRegNum1));
            dataOut2 <= registers(to_integer(readRegNum2));
        end if;
    end process;
end Behavioral;

