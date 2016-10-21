library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rsa_datapath is
 port (      
    -- Clocks and resets
    clk             : in std_logic;
    reset_n         : in std_logic;
    output_mont_ready : out std_logic;
    enable_mont     : in std_logic;
    
    -- Data in interface       
    --msg             : in std_logic_vector (127 downto 0);
    --key             : in std_logic_vector (127 downto 0);
    e               : in std_logic_vector (127 downto 0);
    
    signal a    : in std_logic_vector(127 downto 0);
        signal b    : in std_logic_vector(127 downto 0);
        
        signal n    : in std_logic_vector(127 downto 0);
        signal output    : out std_logic_vector(127 downto 0)
        
    
        
    );
        
end rsa_datapath;


architecture Behavioral of rsa_datapath is

signal u    : std_logic_vector(127 downto 0);
signal state : integer := 0;       

  
begin


process(clk, reset_n) 
variable i : integer := 0;


   begin
   case state is 
   when 0 =>
   output  <= (others => '0'); 
   u <= (others => '0');
          output_mont_ready<='0';
          i  := 0;

   if(clk'event and clk = '1') then
        if(enable_mont = '1') then
            state <= 1;
         else
         state <=0;
         end if;
    end if;
    when 1 =>
    if(reset_n = '0') then
        state<=0;
    elsif(clk'event and clk = '1') then
    if(enable_mont = '1') then
        state <= 1;
     else
     state <=0;
     end if;

    if(i<127) then
       
        if(a(i) = '1') then
        if(u(0) xor b(0)) = '1' then
                u <= std_logic_vector(shift_right(unsigned(u) + unsigned(b) + unsigned(n), integer(1)));      
        
        else
            u <= std_logic_vector(shift_right(unsigned(u) + unsigned(b), integer(1)));
        
        end if; 
        else
        
        
        if(u(0) = '1') then
            u <= std_logic_vector(shift_right(unsigned(u) + unsigned(n), integer(1)));
            
        else
            u <= std_logic_vector(shift_right(unsigned(u), integer(1)));   
        end if;        
        end if;
        
        elsif(i=128) then
            state <= 2;
            if(u>=n) then
               u <= std_logic_vector(unsigned(u) - unsigned(n));               
            end if;
        
        end if;
    i:=i+1;
    end if;
    
    when 2 =>
     
        output <= u(127 downto 0);
        output_mont_ready<='1';
        state <= 0;
         
    when others =>
        state <= 0;
       end case;
    end process;




      
        
            
                        
 
       

        
 
                     
        

   
end Behavioral;
