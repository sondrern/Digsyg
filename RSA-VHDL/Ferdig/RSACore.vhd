library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RSACore is
  port (
    -- Clocks and resets
    Clk             : in std_logic;
    Resetn         : in std_logic;

    -- Control signals for the input inteface   
    InitRsa        : in std_logic;
    StartRsa       : in std_logic;
    DataIn         : in std_logic_vector(31 downto 0);
   
    
    -- Control signals for the output interface
    CoreFinished   : out std_logic;
   
    DataOut       : out std_logic_vector(31 downto 0)
  );
end RSACore;

architecture rtl of RSACore is
  
  -- Increment the shift counter when a new 32-bit chunk is accepted
  signal e      : std_logic_vector(127 downto 0);
  signal n      : std_logic_vector(127 downto 0);  
  signal x      : std_logic_vector(127 downto 0); 
  signal y      : std_logic_vector(127 downto 0); 
  signal m      : std_logic_vector(127 downto 0); 
  signal output_exp      : std_logic_vector(127 downto 0); 
  
  signal enable_exp       : std_logic;
  signal output_exp_ready :  std_logic;
      
--  signal n_r, n_nxt: std_logic_vector(127 downto 0);
--  signal x_r, x_nxt: std_logic_vector(127 downto 0);
--  signal y_r, y_nxt: std_logic_vector(127 downto 0);
signal i : unsigned(7 downto 0);
signal i2 : unsigned(7 downto 0);
signal i3 : unsigned(7 downto 0);

    
begin

  mont_exp : entity work.mont_exp port map(
  -- Clocks and resets
    clk             => Clk,
    reset_n         => Resetn,
    e => e,
    n => n,
    m => m,
    x2 => x,
    r2 => y,
    output_exp => output_exp,
    enable_exp => enable_exp,
    output_exp_ready => output_exp_ready

);

  process (Clk, Resetn) begin
    if(Resetn = '0') then
      e <= (others => '0');
      n <= (others => '0');
      x <= (others => '0');
      y <= (others => '0');
      m <= (others => '0');
      CoreFinished <= '1';
      enable_exp<='0';
      i<=x"10";
      i2<=x"05";
      i3<=x"05";
      
    elsif(Clk'event and Clk='1') then

--        x<=x"7E62394DA8B1ED3C3743B632286AAA03";
--        y <= x"4f4f353b16d9b17cd307f02f393734d9";
      if(InitRsa ='1') then
           CoreFinished <= '0';
           e <= DataIn & e(127 downto 32);
           i<=x"01";
      
      elsif(to_integer(i)<4) then
           i<=i+1;
           e <= DataIn & e(127 downto 32);
      
      elsif(to_integer(i)<8) then
           i<=i+1;
           n <= DataIn & n(127 downto 32);
           --CoreFinished <= '1'; 
           
      
      elsif(to_integer(i)<12) then
           i<=i+1;
           x <= DataIn & x(127 downto 32);
      
      elsif(to_integer(i)<16) then
             i<=i+1;
             y <= DataIn & y(127 downto 32); 
                                  
      elsif(to_integer(i)=16) then
             CoreFinished <= '1';
             i<=i+1;
             
      end if;
      
      if(StartRsa='1') then
        CoreFinished <= '0';
        m <= DataIn & m(127 downto 32);
        i2<=x"01";
      
      elsif(to_integer(i2)<4) then
        --CoreFinished <= '0';
        i2 <= i2 + 1;
        m <= DataIn & m(127 downto 32);
      
      elsif(to_integer(i2)=4) then
        enable_exp <= '1';
        i2<=i2+1;
        
      elsif(to_integer(i2)=5) then
        enable_exp <= '0';
      end if;
        
        
        
     if(output_exp_ready='1' and to_integer(i3)=5) then
      CoreFinished <= '1';
      --enable_exp <= '0';
      DataOut<= output_exp(31 downto 0);
      i3<=x"01";
    
    elsif(to_integer(i3)=1) then
      i3 <= i3 + 1;
      DataOut<= output_exp(63 downto 32);
    
    elsif(to_integer(i3)=2) then
        i3 <= i3 + 1;
        DataOut<= output_exp(95 downto 64);
    
    elsif(to_integer(i3)=3) then
        --i3 <= i3 + 1;
        i3 <= x"05";
        DataOut<= output_exp(127 downto 96);
    
    else
      --enable_exp <= '0';
    end if;
        
    end if;
  end process;
    
 
  
end rtl;
