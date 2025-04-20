import { MessageSquare, Users, Gamepad, Headphones, Phone, Download } from "lucide-react";
import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { useToast } from "@/components/ui/use-toast";

const Index = () => {
  const { toast } = useToast();
  
  const features = [
    {
      icon: <MessageSquare className="w-8 h-8 text-mann-primary" />,
      title: "Role Based AI Chatbot",
      description: "Personalized AI assistance tailored to your specific needs and role"
    },
    {
      icon: <Gamepad className="w-8 h-8 text-mann-primary" />,
      title: "Mood Refreshing Games",
      description: "Enjoy fun games and meme generator to lift your spirits"
    },
    {
      icon: <Headphones className="w-8 h-8 text-mann-primary" />,
      title: "Cosy Environment",
      description: "A comfortable and safe space for you to relax and find peace"
    },
    {
      icon: <Phone className="w-8 h-8 text-mann-primary" />,
      title: "Contact Counsellors",
      description: "Connect with professional counsellor for guidance and support"
    }
  ];

  const scrollToDownload = () => {
    const downloadSection = document.getElementById('download-section');
    downloadSection?.scrollIntoView({ behavior: 'smooth' });
  };

  const handleDownload = () => {
    const apkUrl = 'https://example.com/sample-app.apk';
    
    const link = document.createElement('a');
    link.href = apkUrl;
    link.download = 'mann-app.apk';
    document.body.appendChild(link);
    
    toast({
      title: "Download Started",
      description: "Your download will begin shortly.",
    });
    
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-mann-primary via-mann-secondary to-mann-accent">
      <section className="container mx-auto px-4 pt-20 pb-32 text-white">
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="text-center"
        >
          <h1 className="text-5xl md:text-7xl font-bold mb-6">
            Welcome to MANN
          </h1>
          <p className="text-xl md:text-2xl mb-4 max-w-2xl mx-auto">
            MANN: Man or Women with No Neurological Nuisance
          </p>
          <p className="text-lg md:text-xl mb-12 max-w-2xl mx-auto">
            Your personal space for mental wellness and support
          </p>
          <div className="flex gap-4 justify-center">
            <button 
              onClick={scrollToDownload}
              className="bg-white text-mann-primary px-8 py-3 rounded-full text-lg font-semibold hover:bg-opacity-90 transition-all"
            >
              Get Started
            </button>
            <Link to="/about" className="bg-transparent border-2 border-white text-white px-8 py-3 rounded-full text-lg font-semibold hover:bg-white hover:text-mann-primary transition-all">
              About Us
            </Link>
          </div>
        </motion.div>
      </section>

      <section className="bg-white py-20">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl md:text-4xl font-bold text-center mb-16 text-mann-primary">
            Features that make MANN special
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {features.map((feature, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
                className="feature-card bg-gradient-to-br from-mann-primary/5 to-mann-secondary/5"
              >
                <div className="mb-4">{feature.icon}</div>
                <h3 className="text-xl font-semibold mb-2 text-mann-primary">
                  {feature.title}
                </h3>
                <p className="text-gray-600">
                  {feature.description}
                </p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      <section id="download-section" className="py-20 bg-gradient-to-b from-white to-mann-secondary/10">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold mb-8 text-mann-primary">
            Ready to Get Started?
          </h2>
          <p className="text-xl mb-12 text-gray-600 max-w-2xl mx-auto">
            Join MANN today and take the first step towards your mental wellness journey
          </p>
          <div className="flex flex-col md:flex-row gap-4 justify-center">
            <Button
              onClick={handleDownload}
              className="bg-mann-primary text-white px-8 py-3 rounded-full text-lg font-semibold hover:bg-mann-accent transition-all flex items-center gap-2"
            >
              <Download className="w-5 h-5" />
              Download App
            </Button>
            <button className="border-2 border-mann-primary text-mann-primary px-8 py-3 rounded-full text-lg font-semibold hover:bg-mann-primary hover:text-white transition-all">
              Contact Support
            </button>
          </div>
        </div>
      </section>
    </div>
  );
};

export default Index;
