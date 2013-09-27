function generateHTMLcode(folder,name1,name2,name3, lambda)

str = ['./results.html']; 
fid=fopen(str,'a+');

fprintf(fid,['<%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%>\n']);

fprintf(fid,['<div class="graphic_textbox_style_default" style="height: 70px; margin-left: 20px; position: relative; width: 1150px; z-index: 16; " id="id28">\n']);
fprintf(fid,['<div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 40px; padding-bottom: 0pt; ">  [0]</div>\n']);
fprintf(fid,['<div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 170px; padding-bottom: 0pt; ">  [1]</div>\n']);
fprintf(fid,['<div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 300px; padding-bottom: 0pt; ">  [2]</div>\n']);
fprintf(fid,['<div class="paragraph Body" style=" line-height: 0px; margin-bottom: 0px; margin-top: 10px;margin-left: 30px; padding-bottom: 0pt; font-family:''HoeflerText-Italic'',''Hoefler Text'' ,''Times New Roman'' , ''serif'' ; font-size: 18px; font-style: italic;">f</div>\n']);
fprintf(fid,['<div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 160px; padding-bottom: 0pt; font-family:'' HoeflerText-Italic'','' Hoefler Text'','' Times New Roman'','' serif''; font-size: 18px; font-style: italic;">f</div>\n']);
fprintf(fid,['<div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 290px; padding-bottom: 0pt; font-family:'' HoeflerText-Italic'','' Hoefler Text'','' Times New Roman'','' serif''; font-size: 18px; font-style: italic; ">f</div>\n']);
fprintf(fid,['</div>\n']);
fprintf(fid,['<div style="height: 150px; margin-left: 0px; position: relative; width: 1150px; z-index: 15; " id="body_layer">\n']);
fprintf(fid,['<img src="images/' folder '/Original1' name1 '.png" alt="" id="id34" style="border: none; height: 128px; left: 0px; opacity: 1.00; position: absolute; top: -49px; width: 128px; z-index: 1; " />\n']);
fprintf(fid,['<img src="images/' folder '/Origina3' name3 '.png" alt="" id="id33" style="border: none; height: 128px; left: 130px; opacity: 1.00; position: absolute; top: -49px; width: 128px; z-index: 1; " />\n']);
fprintf(fid,['<img src="images/' folder '/Original2' name2 '.png" alt="" id="id35" style="border: none; height: 128px; left: 260px; opacity: 1.00; position: absolute; top: -49px; width: 128px; z-index: 1; " />\n']);
fprintf(fid,['</div>\n']);

fprintf(fid,['<div style="height: 90px; margin-left: 0px; position: relative; width: 1150px;; z-index: 15; " id="body_layer">\n']);   

for i = 1:size(lambda,2)
    fprintf(fid,['<img src="Images/' folder '/' num2str(i) name1 num2str(lambda(1,i)) '-' name2 num2str(lambda(2,i)) '-' name3 num2str(lambda(3,i)) '.png']);
    fprintf(fid,['" alt="" id="id36" style="border: none; height: 128px; left: ' num2str((i-1)*130) 'px; opacity: 1.00; position: absolute; top: -49px; width: 128px; z-index: 1; " />\n']);
end 

fprintf(fid,['</div>\n']);
fprintf(fid,['<div class="graphic_textbox_style_default" style="height: 150px; margin-left: 20px; position: relative; width: 1150px; z-index: 16; " id="id28">\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 25px; margin-bottom: 0px; margin-top: 0px; padding-top: 0pt; font-family:'' Helvetica''; font-size: 14px; text-decoration: none;">synthesized</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px; padding-top: 0pt;margin-left: 170px; font-family:'' Helvetica''; font-size: 14px; text-decoration: none;">1</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px; padding-top: 0pt;margin-left: 300px; font-family:'' Helvetica''; font-size: 14px; text-decoration: none;">2</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: -15px; padding-top: 0pt;margin-left: 390px; font-family:'' Helvetica''; font-size: 14px; text-decoration: none;">synthesized</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 15px; padding-top: 0pt;margin-left: 560px; font-family:'' Helvetica''; font-size: 14px; text-decoration: none;">3</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px; padding-top: 0pt;margin-left: 690px; font-family:'' Helvetica'';    font-size: 14px; text-decoration: none;">4</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px; padding-top: 0pt;margin-left: 820px; font-family:'' Helvetica''; font-size: 14px; text-decoration: none;">5</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: -15px; padding-top: 0pt;margin-left: 920px; font-family:'' Helvetica''; font-size: 14px; text-decoration: none;">synthesized</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 15px;margin-left: 32px; padding-bottom: 0pt; ">  [0]</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 422px; padding-bottom: 0pt; ">  [1]</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 952px; padding-bottom: 0pt; ">  [2]</div>\n']);

fprintf(fid,['   <div class="paragraph Body" style=" line-height: 0px; margin-bottom: 0px; margin-top: 10px;margin-left: 20px; padding-bottom: 0pt; font-family:'' HoeflerText-Italic'','' Hoefler Text'','' Times New Roman'','' serif''; font-size: 18px; font-style: italic;">f</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 410px; padding-bottom: 0pt; font-family:'' HoeflerText-Italic'','' Hoefler Text'','' Times New Roman'','' serif''; font-size: 18px; font-style: italic;">f</div>\n']);
fprintf(fid,['    <div class="paragraph Body" style="line-height: 0px; margin-bottom: 0px; margin-top: 0px;margin-left: 940px; padding-bottom: 0pt; font-family:'' HoeflerText-Italic'','' Hoefler Text'','' Times New Roman'','' serif''; font-size: 18px; font-style: italic; ">f</div>\n']);

fprintf(fid,['</div>\n']);
fprintf(fid,['<%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%>\n']);

fclose(fid);