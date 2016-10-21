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

entity exp_tb is
--  Port ( );
end exp_tb;

architecture Behavioral of exp_tb is



  constant CLK_PERIOD    : time := 10 ns;
  constant RESET_TIME    : time := 25 ns;

  -- Clocks and resets 
  signal clk            : std_logic := '0';
  signal reset_n        : std_logic := '0';
  signal output_exp_ready   : std_logic := '0';
  signal enable_exp   : std_logic := '0';

  -- Data input interface           
  signal e              : std_logic_vector (127 downto 0);
  signal m              : std_logic_vector (127 downto 0);
  signal m2              : std_logic_vector (127 downto 0);
  signal x2              : std_logic_vector (127 downto 0);  
  signal n              : std_logic_vector (127 downto 0);
  signal output_exp    : std_logic_vector(127 downto 0);



begin

  -- DUT instantiation
  dut: entity work.mont_exp 
    port map (
    
      -- Clocks and resets 
      clk            => clk, 
      reset_n        => reset_n, 
  
      -- Data input interface           
      output_exp_ready  => output_exp_ready,
      enable_exp  => enable_exp,
       e=>e,
       m=>m,
       m2=>m2,
       x2=>x2,
       n=>n,
       output_exp=>output_exp
     
         
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

    -- Send in first test vector
    wait for 2*CLK_PERIOD;
    
    n <= x"00000000000000000000000000000077";
    e <= x"00000000000000000000000000000005";
    m <= x"00000000000000000000000000000013";
    m2<= x"00000000000000000000000000000034";
    x2<= x"00000000000000000000000000000009";
    enable_exp <= '1';
   
    
    -- Wait for results

    wait;
  end process;  


end Behavioral;
