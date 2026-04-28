class EventData {
  final String id;
  final String name;
  final String date;
  final String dateDetail;
  final String location;
  final String description;
  final int likes;
  final double price;
  final double taxRate;
  final List<String> lotes;
  final List<double> lotesPrices;
  final int colorIndex;

  const EventData({
    required this.id,
    required this.name,
    required this.date,
    required this.dateDetail,
    required this.location,
    required this.description,
    required this.likes,
    required this.price,
    required this.taxRate,
    required this.lotes,
    required this.lotesPrices,
    required this.colorIndex,
  });
}

final List<EventData> mockEvents = [
  const EventData(
    id: 'ttt-unicamp',
    name: 'TTT EVENTOS UNICAMP',
    date: '21 SET - 2025',
    dateDetail: '21 de Set 14:00 até 22 de Set às 00:00',
    location: 'Espaço Rodeio Limeira',
    description:
        'A maior festa universitária da região está de volta! O TTT Eventos traz uma experiência única com os melhores DJs, open bar premium e muito mais. Venha fazer parte dessa história que já conta com mais de 10 edições inesquecíveis.\n\nAtrações confirmadas, área VIP exclusiva, food trucks e estacionamento no local. Não perca!',
    likes: 2043,
    price: 75.00,
    taxRate: 0.10,
    lotes: ['1º Lote', '2º Lote', '3º Lote'],
    lotesPrices: [75.00, 95.00, 120.00],
    colorIndex: 0,
  ),
  const EventData(
    id: 'baile-helipa',
    name: 'BAILE DO HELIPA',
    date: '05 OUT - 2025',
    dateDetail: '05 de Out 22:00 até 06 de Out às 06:00',
    location: 'Clube Heliópolis - SP',
    description:
        'O Baile do Helipa voltou com tudo! Uma noite inesquecível com os melhores MCs e DJs do funk. Pista principal, área lounge e muito mais. Vista sua melhor roupa e venha curtir!\n\nLineup especial com artistas surpresa. Não fique de fora dessa!',
    likes: 3421,
    price: 50.00,
    taxRate: 0.10,
    lotes: ['1º Lote', '2º Lote'],
    lotesPrices: [50.00, 70.00],
    colorIndex: 1,
  ),
  const EventData(
    id: 'sunset-vibes',
    name: 'SUNSET VIBES FESTIVAL',
    date: '12 OUT - 2025',
    dateDetail: '12 de Out 15:00 até 13 de Out às 02:00',
    location: 'Praia de Maresias - SP',
    description:
        'O festival mais esperado do litoral paulista! Música eletrônica ao pôr do sol com vista para o mar. Line-up internacional com DJs renomados.\n\nÁrea VIP com open bar, food court gourmet e experiências exclusivas. A vibe perfeita para fechar o feriado!',
    likes: 5102,
    price: 120.00,
    taxRate: 0.10,
    lotes: ['1º Lote', '2º Lote', '3º Lote', 'VIP'],
    lotesPrices: [120.00, 150.00, 180.00, 350.00],
    colorIndex: 2,
  ),
  const EventData(
    id: 'festa-neon',
    name: 'FESTA NEON - UNESP',
    date: '18 OUT - 2025',
    dateDetail: '18 de Out 22:00 até 19 de Out às 05:00',
    location: 'Ginásio UNESP Araraquara',
    description:
        'A lendária Festa Neon da UNESP está de volta! Tintas neon, luzes UV e os melhores hits. Uma experiência visual e sonora única que você não pode perder.\n\nVenha de branco e se prepare para muita tinta, diversão e energia!',
    likes: 1876,
    price: 40.00,
    taxRate: 0.10,
    lotes: ['1º Lote', '2º Lote'],
    lotesPrices: [40.00, 55.00],
    colorIndex: 3,
  ),
  const EventData(
    id: 'calourada-usp',
    name: 'CALOURADA USP 2025',
    date: '25 OUT - 2025',
    dateDetail: '25 de Out 20:00 até 26 de Out às 04:00',
    location: 'CEPEUSP - Cidade Universitária',
    description:
        'A maior calourada do país! Receba os bixos com muita festa, música e integração. Atrações de sertanejo, funk e eletrônica em 3 palcos simultâneos.\n\nBem-vindos à USP! Uma noite que vocês nunca vão esquecer.',
    likes: 8234,
    price: 35.00,
    taxRate: 0.10,
    lotes: ['Bixo', 'Veterano', 'Convidado'],
    lotesPrices: [20.00, 35.00, 45.00],
    colorIndex: 4,
  ),
  const EventData(
    id: 'rave-subterranea',
    name: 'RAVE SUBTERRÂNEA',
    date: '01 NOV - 2025',
    dateDetail: '01 de Nov 23:00 até 02 de Nov às 10:00',
    location: 'Galpão Secreto - Campinas',
    description:
        'Uma experiência underground de techno e house. Local revelado apenas 24h antes do evento. Line-up com DJs internacionais e nacionais.\n\nCapacidade limitada. Garanta seu ingresso antes que esgote!',
    likes: 1245,
    price: 90.00,
    taxRate: 0.10,
    lotes: ['Early Bird', 'Regular'],
    lotesPrices: [90.00, 130.00],
    colorIndex: 5,
  ),
];
