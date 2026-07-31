% Input: a couple
%
% Example:
% realtime_ticker('ppc_btc')
%
% Output:
% A structure with the values for:
% high
% low
% avg
% vol
% vol_cur
% buy
% sell
% updated
% server_time

function ticker = realtime_ticker(couple)

    if nargin == 0
        couple = 'ppc_btc';
    end

    url = ['https://btc-e.com/api/2/' couple '/ticker'];

    html = urlread(url)

    index = regexp(html,'high":');
    html = html(index+6:end);
    index = regexp(html,',"low":');
    html_split = html(1:index-1);
    ticker.high = str2double(html_split);

    html = html(index+7:end);
    index = regexp(html,',"avg"');
    html_split = html(1:index-1);
    ticker.low = str2double(html_split);

    html = html(index+7:end);
    index = regexp(html,',"vol"');
    html_split = html(1:index-1);
    ticker.avg = str2double(html_split);
    
    html = html(index+7:end);
    index = regexp(html,',"vol_cur"');
    html_split = html(1:index-1);
    ticker.vol = str2double(html_split);

    html = html(index+11:end);
    index = regexp(html,',"last"');
    html_split = html(1:index-1);
    ticker.vol_cur = str2double(html_split);

    html = html(index+8:end);
    index = regexp(html,',"buy"');
    html_split = html(1:index-1);
    ticker.last = str2double(html_split);

    html = html(index+7:end);
    index = regexp(html,',"sell"');
    html_split = html(1:index-1);
    ticker.buy = str2double(html_split);

    html = html(index+8:end);
    index = regexp(html,',"updated"');
    html_split = html(1:index-1);
    ticker.sell = str2double(html_split);

    html = html(index+11:end);
    index = regexp(html,',"server_time');
    html_split = html(1:index-1);
    ticker.updated = str2double(html_split);

    html = html(index+15:end);
    index = regexp(html,'}}');
    html_split = html(1:index-1);
    ticker.server_time = str2double(html_split);
end