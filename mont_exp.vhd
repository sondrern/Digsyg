----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2016 05:13:04 PM
-- Design Name: 
-- Module Name: mont_exp - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mont_exp is
  Port ( 
      clk             : in std_logic;
      reset_n         : in std_logic;
      --output_mont_ready : in std_logic;
      --enable_mont     : out std_logic;
      enable_exp     : in std_logic;
      output_exp_ready     : out std_logic;
      
      -- Data in interface       
      signal e    : in std_logic_vector (127 downto 0);
      signal x2    : in std_logic_vector (127 downto 0);
      signal m    : in std_logic_vector(127 downto 0);
      signal m2    : in std_logic_vector(127 downto 0);
      signal n    : in std_logic_vector(127 downto 0);
      signal output_exp    : out std_logic_vector(127 downto 0)
  );
end mont_exp;

architecture Behavioral of mont_exp is
signal x    : std_logic_vector(127 downto 0);
signal a    : std_logic_vector(127 downto 0);
signal b    : std_logic_vector(127 downto 0);
signal output    : std_logic_vector(127 downto 0);
signal output_mont_ready    : std_logic;
signal enable_mont    : std_logic;
--signal state : integer := 0; 
signal counter : integer := 2; 
--signal nxt_state : integer := 0; 

type state is (idle, mont1, mont2, mont3, finish, decrement);
signal pre_state, nxt_state : state;       
begin

  rsa_datapath : entity work.rsa_datapath port map(
  -- Clocks and resets
    clk             => clk,
    reset_n         => reset_n,
    a => a,
    b => b,
    e => e,
    output => output,
    output_mont_ready => output_mont_ready,
    enable_mont => enable_mont,
    n => n

);

process(clk, reset_n) 
begin
if(reset_n='0') then 
pre_state <= idle;

elsif(clk'event and clk = '1') then
    pre_state <= nxt_state;
end if;
end process;

process(pre_state, enable_exp, output_mont_ready) begin
case pre_state is
when idle => 
    output_exp <= (others => '0'); 
    output_exp_ready<='0';
    enable_mont <= '0';
        if(enable_exp='1') then
            nxt_state<=mont1;
            x<=x2;
        end if;

when mont1 =>
    enable_mont <= '1';
    a<=x;
    b<=x;
    if(output_mont_ready = '1') then
        if (e(counter) = '1') then
            nxt_state <= mont2;
            x<=output;
        else
        nxt_state<=decrement;
        x<=output;
        end if;
    end if;
    if(counter=-1) then
        nxt_state <= mont3;
    end if;
    
    
when decrement =>
   
        nxt_state <=mont1;
        counter <= counter - 1;
   
    
when mont2 =>
    enable_mont <='1';
    a<=m2;
    b<=x;
    if(output_mont_ready = '1') then
    
            nxt_state<=decrement;
            x<=output;
    end if;

when mont3 =>
    enable_mont <='1';
    a<=x;
    b<=x"00000000000000000000000000000001";
    if(output_mont_ready = '1') then
 
            nxt_state<=finish;
            x<=output;
    end if;

when finish =>
    output_exp_ready<='1';
    output_exp<=x;
    
when others =>
    nxt_state <= idle;
    
end case;    
end process;
end Behavioral;
