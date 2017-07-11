class CapaController < ApplicationController


  def index
    get_instagram(0)
  end

  def show
  end

  def carregar_mais
    @max_tag_id = params['max_tag_id']# Pega parametro que veio junto no post, index da primeira foto do novo grupo ex. 1-13-25
    get_instagram(@max_tag_id)
    @max_tag_id = @max_tag_id.to_i + 12# Soma 12 para chegar ao proximo index e printar no input hidden na view
    respond_to do |format|
      format.js
    end
  end

  def get_instagram(index)
    # Bloco referente ao feed do instagram
    require 'net/http'
    url = URI.parse('https://www.instagram.com/explore/tags/winpf/?__a=1')
    begin
      resp = Net::HTTP.get_response(url)
    rescue Errno::ETIMEDOUT, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse => e
      resp = false
    end
    @images = [] # Limpa array para não printar fotos que já estão na view
    @photo_user_data = []
    @total_comments = []

    @vet_comenarios = []
    @comments = []
    @start = 0

    p "Começo = #{@comeco}"
    unless resp == false
      parsed_json = JSON.parse(resp.body)
      min = index.to_i
      max = index.to_i + 11

      for i in min..max
        if parsed_json['tag']['media']['nodes'][i].nil?  # Se objeto não existe, quer dizer que acabaram as fotos disponíveis
          @acabou = true
          return
        else
          @images << [parsed_json['tag']['media']['nodes'][i]['thumbnail_src'] ,
          parsed_json['tag']['media']['nodes'][i]['code']  ,
          parsed_json['tag']['media']['nodes'][i]['comments']['count'] ,
          parsed_json['tag']['media']['nodes'][i]['likes']['count'] ,
          parsed_json['tag']['media']['nodes'][i]['is_video'] ,
          parsed_json['tag']['media']['nodes'][i]['video_views'] ]


          shortcode = "#{@images[i][1]}"
          p "shortcode: #{@images[i][1]}"
          url_user = 'https://www.instagram.com/p/'
          url_user += shortcode + '/?__a=1'
          url_user = URI.parse(url_user)
          begin
            resposta = Net::HTTP.get_response(url_user)
          rescue Errno::ETIMEDOUT, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse => e
            resposta = false
          end
          unless resposta == false
            json_parsed = JSON.parse(resposta.body)

            @photo_user_data << [ json_parsed['graphql']['shortcode_media']['edge_media_to_caption']['edges'][0]['node']['text'] ,
            json_parsed['graphql']['shortcode_media']['owner']['username'] ,
            json_parsed['graphql']['shortcode_media']['owner']['profile_pic_url'],
            json_parsed['graphql']['shortcode_media']['location']['name'] ]

            @total_comments << [ json_parsed['graphql']['shortcode_media']['edge_media_to_comment']['count'] ]
            p "total_comments indice i = #{@total_comments[i][0]}"

            total = @total_comments[i][0]
            p "Total = #{total}"

            if total > 0

              for j in 0..total-1
                @comments.push([ json_parsed['graphql']['shortcode_media']['edge_media_to_comment']['edges'][j]['node']['text'],
                  json_parsed['graphql']['shortcode_media']['edge_media_to_comment']['edges'][j]['node']['owner']['username'] ] )

                p "Comentario posicao [#{j}]: #{@comments}"
              end
              # @vet_comenarios.insert(i, @comments)
            end
            # p "@vet_comenarios[i] = #{@vet_comenarios}"


          end



        end
      end # final for

    end
    # Fim do bloco referente ao feed do instagram

  end



end
