library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rsa_controll is
  port (
    -- Clocks and resets
    clk             : in std_logic;
    reset_n         : in std_logic;

    -- Control signals for the input inteface   
    init_rsa        : in std_logic;
    start_rsa       : in std_logic;
    data_in         : in std_logic_vector(31 downto 0);
   
    
    -- Control signals for the output interface
    core_finished   : out std_logic;
   
    data_out        : out std_logic_vector(31 downto 0)
  );
end rsa_controll;

architecture rtl of rsa_controll is
  
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
    clk             => clk,
    reset_n         => reset_n,
    e => e,
    n => n,
    m => m,
    x2 => x,
    r2 => y,
    output_exp => output_exp,
    enable_exp => enable_exp,
    output_exp_ready => output_exp_ready

);

  process (clk, reset_n) begin
    if(reset_n = '0') then
      e <= (others => '0');
      n <= (others => '0');
      x <= (others => '0');
      y <= (others => '0');
      m <= (others => '0');
      core_finished <= '1';
      enable_exp<='0';
      i<=x"10";
      i2<=x"05";
      i3<=x"05";
      
    elsif(clk'event and clk='1') then
      if(init_rsa ='1') then
           core_finished <= '0';
           e <= data_in & e(127 downto 32);
           i<=x"01";
      
      elsif(to_integer(i)<4) then
           i<=i+1;
           e <= data_in & e(127 downto 32);
      
      elsif(to_integer(i)<8) then
           i<=i+1;
           n <= data_in & n(127 downto 32);
      
      elsif(to_integer(i)<12) then
           i<=i+1;
           x <= data_in & x(127 downto 32);
      
      elsif(to_integer(i)<16) then
             i<=i+1;
             y <= data_in & y(127 downto 32); 
             core_finished <= '1';                     
      
      end if;
      
      if(start_rsa='1') then
        core_finished <= '0';
        m <= data_in & m(127 downto 32);
        i2<=x"01";
      
      elsif(to_integer(i2)<4) then
        i2 <= i2 + 1;
        m <= data_in & m(127 downto 32);
      
      elsif(to_integer(i2)=4) then
        enable_exp <= '1';
      end if;
        
        
        
     if(output_exp_ready='1' and i3=5) then
      core_finished <= '1';
      data_out <= output_exp(31 downto 0);
      i3<=x"01";
    
    elsif(to_integer(i3)=1) then
      i3 <= i3 + 1;
      data_out <= output_exp(63 downto 32);
    
    elsif(to_integer(i3)=2) then
        i3 <= i3 + 1;
        data_out <= output_exp(95 downto 64);
    
    elsif(to_integer(i3)=3) then
        i3 <= i3 + 1;
        data_out <= output_exp(127 downto 96);
    
    else
      --enable_exp <= '0';
    end if;
        
    end if;
  end process;
    
 
  
end rtl;

