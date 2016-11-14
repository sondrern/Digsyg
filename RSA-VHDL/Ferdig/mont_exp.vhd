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
use ieee.numeric_std.all;

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
      signal r2    : in std_logic_vector(127 downto 0);
      signal n    : in std_logic_vector(127 downto 0);
      signal output_exp    : out std_logic_vector(127 downto 0)
  );
end mont_exp;

architecture Behavioral of mont_exp is
signal x    : std_logic_vector(131 downto 0);
signal a    : std_logic_vector(131 downto 0);
signal b    : std_logic_vector(131 downto 0);
signal output    : std_logic_vector(131 downto 0);
signal m2    : std_logic_vector(131 downto 0);
signal output_mont_ready    : std_logic;
signal enable_mont    : std_logic;
--signal state : integer := 0; 
signal counter : unsigned(7 downto 0);
signal counter2 : unsigned(7 downto 0); 
--signal nxt_state : integer := 0; 

type state is (idle, mont1, mont2, mont3, finish, decrement, start, state2, state1, state3, init, state4);
signal pre_state : state;       
begin

  rsa_datapath : entity work.rsa_datapath port map(
  -- Clocks and resets
    clk             => clk,
    reset_n         => reset_n,
    a => a,
    b => b,
    output => output,
    output_mont_ready => output_mont_ready,
    enable_mont => enable_mont,
    n => n

);

process(clk, reset_n) 
begin
if(reset_n='0') then 
pre_state <= idle;
counter<=x"7F";
    counter2<=x"7F";
    output_exp <= (others => '0'); 
    output_exp_ready<='0';
    enable_mont <= '0';

elsif(clk'event and clk = '1') then
    case pre_state is
when idle => 
    counter<=x"7F";
    counter2<=x"7F";
    --output_exp <= (others => '0'); 
    output_exp_ready<='0';
    enable_mont <= '0';
        if(enable_exp='1') then
            pre_state<=init;
            x<=x"0" & x2;
        end if;

when init =>
enable_mont <='1';
    a<=x"0" & r2;
    b<=x"0" & m(127 downto 0);
    if(output_mont_ready = '1') then
            enable_mont <= '0';        
            pre_state<=state4;
            m2<=output;
    end if;
    

when start =>
    if(e(to_integer(counter2))='1') then
        pre_state <= mont1;
        counter<=counter2;
    else
        counter2 <= counter2 - 1;
        if(counter2 = 0) then 
            pre_state <= idle;
        end if;
            
    end if;




when mont1 =>
    enable_mont <= '1';
    a<=x;
    b<=x;
    if(output_mont_ready = '1') then
        enable_mont <= '0';
        if (e(to_integer(counter)) = '1') then
            pre_state <= state2;
            x<=output;
        else
        pre_state<=state1;
        x<=output;
        end if;
    end if;
    if(counter=x"FF") then
        a<=x;
       b<=x"000000000000000000000000000000001";
        pre_state <= mont3;
    end if;
    
when state2 =>
if(output_mont_ready = '0') then
    pre_state<=mont2;
end if;      

when state1=>
if(output_mont_ready = '0') then
    pre_state<=decrement;
end if;

when state3=>
if(output_mont_ready = '0') then
    pre_state<=decrement;
end if;

when state4=>
if(output_mont_ready = '0') then
    pre_state<=start;
end if;
 
when decrement =>
   
        pre_state <=mont1;
        counter <= counter - 1;
   
    
when mont2 =>
    enable_mont <='1';
    a<=m2;
    b<=x;
    if(output_mont_ready = '1') then
            enable_mont <= '0';        
            pre_state<=state3;
            x<=output;
    end if;

when mont3 =>
    enable_mont <='1';
    a<=x;
    b<=x"000000000000000000000000000000001";
    if(output_mont_ready = '1') then
            enable_mont <= '0';
            pre_state<=finish;
            x<=output;
    end if;

when finish =>
    output_exp_ready<='1';
    output_exp<=x(127 downto 0);
    pre_state<=idle;
    
when others =>
    pre_state <= idle;
    
end case;
end if;
end process;

end Behavioral;
