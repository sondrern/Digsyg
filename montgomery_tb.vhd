----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/10/2016 09:32:53 AM
-- Design Name: 
-- Module Name: montgomery_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity montgomery_tb is
--  Port ( );
end montgomery_tb;

architecture Behavioral of montgomery_tb is



  constant CLK_PERIOD    : time := 10 ns;
  constant RESET_TIME    : time := 25 ns;

  -- Clocks and resets 
  signal clk            : std_logic := '0';
  signal reset_n        : std_logic := '0';

  -- Data input interface           
  signal a              : std_logic_vector (127 downto 0);
  signal b              : std_logic_vector (127 downto 0);
  signal n              : std_logic_vector (127 downto 0);  
  signal e              : std_logic_vector (127 downto 0);
  
  signal output              : std_logic_vector (127 downto 0);

begin

  -- DUT instantiation
  dut: entity work.rsa_datapath 
    port map (
    
      -- Clocks and resets 
      clk            => clk, 
      reset_n        => reset_n, 
  
      -- Data input interface           
      a => a,
      b => b,
      e => e,
      
      output => output,
      n => n
         
    );

  -- Clock generation
  clk <= not clk after CLK_PERIOD/2;

  -- Reset generation
  reset_proc : process
    begin
        wait for RESET_TIME;
        reset_n <= '1';
        wait;
    end process;


  -- Stimuli generation
  stimuli_proc: process
  begin
  a <= x"00000000000000000000000000000000";
      b <= x"00000000000000000000000000000000";
    -- Send in first test vector
    wait for 2*CLK_PERIOD;
    
    n <= x"00000000000000000000000000000010";
    e <= x"00000000000000000000000000000003";
    a <= x"00000000000000000000000000000003";
    b <= x"00000000000000000000000000000003";
    
   
    
    -- Wait for results

    wait;
  end process;  


end Behavioral;
