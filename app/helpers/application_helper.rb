#coding: utf-8
module ApplicationHelper

  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
      when 0..1
        return (distance_in_minutes == 0) ? '不到1分钟' : '1分钟' unless include_seconds
        return "#{distance_in_seconds}秒"
      when 2..60
        return "#{distance_in_minutes}分钟"
      when 61..1439
        return "#{(distance_in_minutes.to_f / 60.0).round}小时"
      when 1440..43199
        return "#{(distance_in_minutes / 1440).round} 天"
      when 43200..525599
        return "#{(distance_in_minutes / 43200).round} 个月"
      else
        return "#{(distance_in_minutes / 525600).round} 年"
      end
    end

end
