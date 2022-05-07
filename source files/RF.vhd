----------------------------------------------------------------------------------
-- Company: Technical University of Crete	
-- Engineer: Georgios Agoritsis
-- 
-- Create Date:    22:19:51 04/10/2021 
-- Design Name: 
-- Module Name:    RF - Behavioral 
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

use work.mux_pack.all;

entity RF is
	   Port ( CLK : in STD_LOGIC;
				RST : in STD_LOGIC;
				WrEn: in STD_LOGIC;
				CDB_Q : in  STD_LOGIC_VECTOR (4 downto 0);
			   CDB_V : in  STD_LOGIC_VECTOR (31 downto 0);
				RS_tag : in STD_LOGIC_VECTOR (4 downto 0); --in which RS the instruction is issued
				Ri : in  STD_LOGIC_VECTOR (4 downto 0);
				Rj : in  STD_LOGIC_VECTOR (4 downto 0);
				Rk : in  STD_LOGIC_VECTOR (4 downto 0);
			   Qjout : out  STD_LOGIC_VECTOR (4 downto 0);
			   Vjout : out  STD_LOGIC_VECTOR (31 downto 0);
				Qkout : out  STD_LOGIC_VECTOR (4 downto 0);
			   Vkout : out  STD_LOGIC_VECTOR (31 downto 0)
				);
end RF;

architecture Behavioral of RF is

component RF_Register is
	   Port (CLK : in STD_LOGIC;
				RST	: in STD_LOGIC;
				WrEn: in STD_LOGIC;
				Issue_RS_tag : in  STD_LOGIC_VECTOR (4 downto 0); -- to initialize Q from Issue Unit
				CDB_Q : in  STD_LOGIC_VECTOR (4 downto 0);
			   CDB_V : in  STD_LOGIC_VECTOR (31 downto 0);
				Qout : out  STD_LOGIC_VECTOR (4 downto 0);
			   Vout : out  STD_LOGIC_VECTOR (31 downto 0)
				);
end component;

component RF_register_value1 is
	   Port ( CLK : in STD_LOGIC;
				RST	: in STD_LOGIC;
				WrEn: in STD_LOGIC;
				Issue_RS_tag : in  STD_LOGIC_VECTOR (4 downto 0); -- to initialize Q from Issue Unit
				CDB_Q : in  STD_LOGIC_VECTOR (4 downto 0);
			   CDB_V : in  STD_LOGIC_VECTOR (31 downto 0);
				Qout : out  STD_LOGIC_VECTOR (4 downto 0);
			   Vout : out  STD_LOGIC_VECTOR (31 downto 0)
				);
end component;

component Decoder is
    Port ( Awr : in std_logic_vector (4 downto 0);
           Dout : out std_logic_vector (31 downto 0));
end component;

component MUX32_1 is
    Port ( Min : in muxIn;
           Control : in STD_LOGIC_VECTOR (4 downto 0);
           Mout : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUX32_1_5bits is
    Port ( Min : in muxIn5bits;
           Control : in STD_LOGIC_VECTOR (4 downto 0);
           Mout : out STD_LOGIC_VECTOR (4 downto 0));
end component;

signal temp_wren : std_logic_vector(31 downto 0);
signal temp_decoder_out: std_logic_vector(31 downto 0);
signal temp_reg_vout:  muxIn;
signal temp_reg_qout:  muxIn5bits;
signal temp_cdb_v:  std_logic_vector(31 downto 0);
signal temp_cdb_q:  std_logic_vector(4 downto 0);
signal temp_vk_out:  std_logic_vector(31 downto 0);
signal temp_qk_out:  std_logic_vector(4 downto 0);
signal temp_vj_out:  std_logic_vector(31 downto 0);
signal temp_qj_out:  std_logic_vector(4 downto 0);
signal temp_final_vk_out:  std_logic_vector(31 downto 0);
signal temp_final_qk_out:  std_logic_vector(4 downto 0);
signal temp_final_vj_out:  std_logic_vector(31 downto 0);
signal temp_final_qj_out:  std_logic_vector(4 downto 0);


begin

dec:
    Decoder port map(Awr=>Ri, Dout=>temp_decoder_out); 

write_enable:
    for i in 1 to 31 generate
        temp_wren(i)<= (WrEn and temp_decoder_out(i));
    end generate write_enable;
	 temp_wren(0)<='1';

Gen_RF_reg:
    for I in 1 to 31 generate
        regx : RF_Register port map(CLK=>CLK,
                                WrEn=>temp_wren(I),
                                RST=>RST,
                                CDB_Q=>CDB_Q,
                                CDB_V=>CDB_V,
										  Issue_RS_tag=>RS_tag,
										  Qout=>temp_reg_qout(I),
										  Vout=>temp_reg_vout(I)); --ta out tha sindethoun me to temp_reg_qout(I) kai temp_reg_vout(I) (kai isws ena akoma signal)`123
    end generate Gen_RF_reg;
reg0:  RF_Register_value1 port map(CLK=>CLK,
									  WrEn=>temp_wren(0),
									  RST=>RST,
									  CDB_Q=>"00000",
									  CDB_V=>x"00000002",
									  Issue_RS_tag=>"00000",
									  Qout=>temp_reg_qout(0),
									  Vout=>temp_reg_vout(0));
									  
mux1:
    MUX32_1 port map( Min=>temp_reg_vout,Control=>Rj,Mout=>temp_vj_out); 

mux2:
    MUX32_1_5bits port map( Min=>temp_reg_qout,Control=>Rj,Mout=>temp_qj_out);
	 
mux3:
    MUX32_1 port map( Min=>temp_reg_vout,Control=>Rk,Mout=>temp_vk_out);

mux4:
    MUX32_1_5bits port map( Min=>temp_reg_qout,Control=>Rk,Mout=>temp_qk_out); 

--fall through
process(CLK,CDB_Q,temp_qj_out, temp_qk_out,temp_vk_out,temp_vj_out)
begin
	if falling_edge(CLK) then
		if (CDB_Q=temp_qj_out and CDB_Q/=temp_qk_out and CDB_Q/="00000") then
			temp_final_qj_out<="00000";
			temp_final_vj_out<=CDB_V;
			temp_final_qk_out<=temp_qk_out;
			temp_final_vk_out<=temp_vk_out;
			
		elsif (CDB_Q/=temp_qj_out and CDB_Q=temp_qk_out and CDB_Q/="00000") then
			temp_final_qj_out<=temp_qj_out;
			temp_final_vj_out<=temp_vj_out;
			temp_final_qk_out<="00000";
			temp_final_vk_out<=CDB_V;
		
		elsif (CDB_Q=temp_qj_out and CDB_Q=temp_qk_out and CDB_Q/="00000") then	
			temp_final_qj_out<="00000";
			temp_final_vj_out<=CDB_V;
			temp_final_qk_out<="00000";
			temp_final_vk_out<=CDB_V;

		else
			temp_final_qj_out<=temp_qj_out;
			temp_final_vj_out<=temp_vj_out;
			temp_final_qk_out<=temp_qk_out;
			temp_final_vk_out<=temp_vk_out;

		end if;
	end if;
end process;

Qjout<=temp_final_qj_out;
Vjout<=temp_final_vj_out;
Qkout<=temp_final_qk_out;
Vkout<=temp_final_vk_out;



end Behavioral;

