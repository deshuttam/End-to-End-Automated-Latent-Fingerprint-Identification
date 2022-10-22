% GENERATING FMR AND FNMR DATA
%
% Usage:  build_fmr;
%
% Argument:   Nothing
%               

% Vahid. K. Alilou
% Department of Computer Engineering
% The University of Semnan
%
% July 2013

function  build_fmr_NISTSD27_Final()
cd 'F:\PhD\Software\Matlab\Simple_FingerPrint_Matching\'; 
load('db.mat'); 
    P=258;
    %P=10;
    fmr=zeros(100,P); fnmr=zeros(100,P);
    for p=1:258
        ffnew=ff{p};
        S=zeros(258,1);
        %S=zeros(10,1);
        %for i=1:258
         for i=1:258
            %second=['10' num2str(fix((i-1)/8)+1) '_' num2str(mod(i-1,8)+1)];
            %second=[num2str(mod(i-1,258)+1) '.bmp'];
            second=[num2str(i) '.bmp'];
            
            S(i)=match(ffnew,ff{i});
            %fprintf(['\n' num2str(i)]);
        end
        %gt=[1 2 3 4 5 6 7 8]+(fix((p-1)/8)*8); k=0;
        %gt=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257]+(fix((p-1)/258)*258); k=0;
        gt=[1]+(fix((p-1)/258)*258); k=0;
        
        for a=0.01:.01:1
            k=k+1; s=0;
            g=find(S>a);
            for i=1:length(gt)
                s=s+sum(g==gt(i));
            end
            fmr(k,p)=(length(g)-s)/258;
            fnmr(k,p)=1-s/1;
        end
        fprintf(['\n' num2str(p)]);
    end
    save('fmr.mat','fmr');
    save('fnmr.mat','fnmr');
end