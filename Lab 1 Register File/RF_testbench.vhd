library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RF_testbench is
end RF_testbench;

architecture Behavioral of RF_testbench is
    constant CLK_PERIOD : time := 10 ns; -- Define clock period
    signal clk : std_logic := '1'; -- Clock signal
    signal regWrite : std_logic := '0'; -- Register write control
    signal writeRegNum : unsigned(4 downto 0) := (others => '0'); -- Write register number
    signal readRegNum1 : unsigned(4 downto 0) := (others => '0'); -- Read register number 1
    signal readRegNum2 : unsigned(4 downto 0) := (others => '0'); -- Read register number 2
    signal dataIn : std_logic_vector(31 downto 0) := (others => '0'); -- Data to be written
    signal dataOut1 : std_logic_vector(31 downto 0); -- Data output from register 1
    signal dataOut2 : std_logic_vector(31 downto 0); -- Data output from register 2
begin
    -- Instantiate the RegisterFile module
    uut: entity work.RegisterFile
        port map (
            clk => clk,
            regWrite => regWrite,
            writeRegNum => writeRegNum,
            readRegNum1 => readRegNum1,
            readRegNum2 => readRegNum2,
            dataIn => dataIn,
            dataOut1 => dataOut1,
            dataOut2 => dataOut2
        );

    -- Clock process
    clk_process: process
    begin
        while now < 1000 ns loop
            clk <= '1';
            wait for CLK_PERIOD / 2;
            clk <= '0';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process clk_process;

    -- Test process
    test_process: process
    begin
        -- Test case 1: Write to register 1 and 4 
        wait for 50 ns;
        regWrite <= '1';
        writeRegNum <= to_unsigned(1, 5);
        dataIn <= x"00000001";
        wait for CLK_PERIOD;
 	writeRegNum <= to_unsigned(4, 5);
        dataIn <= x"00000002";
        wait for CLK_PERIOD;
	regWrite <= '0';

	-- Test case 2: read from registers 1 and 4
        wait for 50 ns;
        readRegNum1 <= to_unsigned(1, 5);
        readRegNum2 <= to_unsigned(4, 5);
        wait for CLK_PERIOD;

        -- Test case 3 : write and read in same register at same clock cycle
	wait for 50 ns;
        regWrite <= '1';
        writeRegNum <= to_unsigned(1, 5);
        dataIn <= x"00000003";
        readRegNum1 <= to_unsigned(1, 5);
        readRegNum2 <= to_unsigned(4, 5);
        wait for CLK_PERIOD;
	regWrite <= '0';

      	-- Test case 4 : write when regWrite = 0 
	wait for 50 ns;
        regWrite <= '0';
        writeRegNum <= to_unsigned(1, 5);
        dataIn <= x"00000004";
        readRegNum1 <= to_unsigned(1, 5);
        readRegNum2 <= to_unsigned(4, 5);
        wait for CLK_PERIOD;
	regWrite <= '0';
        wait;
    end process test_process;
end Behavioral;

