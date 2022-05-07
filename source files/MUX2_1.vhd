----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:42:41 07/04/2021 
-- Design Name: 
-- Module Name:    MUX2_1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX2_1 is
    Port ( sel : in  STD_LOGIC;
			  datain0 : in  STD_LOGIC_VECTOR (31 downto 0);
           datain1 : in  STD_LOGIC_VECTOR (31 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX2_1;

architecture Behavioral of MUX2_1 is

signal tempOut: std_logic_vector(31 downto 0);

begin
process(sel,datain0, datain1,tempOut)
begin
	if(sel = '0') then 
	    tempOut<=datain0;
	else
	    tempOut<=datain1;
	end if;
	
end process;
dataout<=tempOut;
end Behavioral;

