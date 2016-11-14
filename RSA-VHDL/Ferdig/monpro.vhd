library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity monpro is
 port (      
    -- Clocks and resets
    clk               : in  std_logic;
    reset_n           : in  std_logic;
    output_mont_ready : out std_logic;
    enable_mont       : in  std_logic;
    
    -- Data in interface       
    --msg             : in std_logic_vector (127 downto 0);
    --key             : in std_logic_vector (127 downto 0);
    
    signal a    : in std_logic_vector(131 downto 0);
    signal b    : in std_logic_vector(131 downto 0);
        
    signal n    : in std_logic_vector(127 downto 0);
    signal output    : out std_logic_vector(131 downto 0)
        
        
    
        
    );
        
end monpro;


architecture rtl of monpro is

signal u        : unsigned(131 downto 0);
signal i        : unsigned(7 downto 0);
--signal flag : integer := 0;
signal flag     : std_logic;
signal alen     : unsigned(7 downto 0);
signal nlen     : unsigned(7 downto 0);
signal counter2 : unsigned(7 downto 0);

type state is (idle, mainloop, increment, finish, comp_out, state2, start, red);
signal pre_state: state;      

begin

process(clk, reset_n) 
begin
  if(reset_n='0') then
    pre_state         <= idle;
    u                 <= (others => '0');
    counter2          <= x"7F";
    alen              <= x"7F";
    nlen              <= x"80";
    flag              <='0';
    output_mont_ready <='0';
    i                 <= x"00";
    output            <= (others => '0');
  
  elsif(clk'event and clk='1') then
  
    case pre_state is 
     
      when idle =>      
        u                 <= (others => '0');
        counter2          <= x"7F";
        alen              <= x"7F";
        nlen              <= x"80";
        flag              <='0';
        output_mont_ready <='0';
        i                 <= x"00";
        if(enable_mont = '1') then
          pre_state <= start;
        end if;
           
      when start =>          
  
        if(n(to_integer(counter2))='1' and flag='0') then
          nlen      <= counter2+1;
          flag      <= '1';
          pre_state <= start;
        end if;
        
        if(a(to_integer(counter2))='1') then
          pre_state <= mainloop;
          alen<=counter2+1;
        else
          counter2 <= counter2 - 1;
          if(counter2 = 0) then 
            pre_state <= idle;
          end if;       
        end if;
      
  when mainloop =>
      if(i<alen) then
          pre_state<=increment;
          if(a(to_integer(i)) = '1') then
          if(u(0) xor b(0)) = '1' then
                  --u <= unsigned(unsigned(u)+unsigned(b)); --+ unsigned(n);
                  u <= u + unsigned(b) + unsigned(n);      
          
          else
              u <= unsigned(u) + unsigned(b);
          
          end if; 
          else
              if(u(0)) = '1' then
                  u <= unsigned(u) + unsigned(n);
              end if;        
          end if;        
  
          
          elsif(i=alen) then
              pre_state <= state2;
              --nxt_state <= increment;
  
          end if;
      
      when state2 =>
          if(alen=nlen) then
              pre_state<=comp_out;
          else    
          if(u(0)='1') then
                  u <= unsigned(u) + unsigned(n);
          end if;
          nlen<=nlen-1;
          pre_state<=increment;
          end if;
              
      when increment =>
          u <= shift_right(unsigned(u),integer(1));
          if(i<alen) then
          i <= i+1;
          pre_state<=mainloop;
          else
          if(nlen-alen>0) then
              i  <= i;
              pre_state<=state2;
              
          else  
          i  <= i;  
          pre_state<=comp_out;
          end if;
          end if;
          
      when comp_out =>
          if(u(127 downto 0)>=unsigned(n)) then
             u <= unsigned(u) - unsigned(n);               
             pre_state<=red; 
          else 
          pre_state<=finish;
          output_mont_ready<='1'; 
          output<=std_logic_vector(u); 
          end if;    
  
      when red=>
          pre_state<=comp_out;
          
      when finish =>
          output_mont_ready<='0'; 
          output<=std_logic_vector(u);      
          pre_state <= idle;
           
      when others =>
        output_mont_ready<='0';
        pre_state <= idle;
    end case;
    
    
  end if;
end process;
   
end rtl;
